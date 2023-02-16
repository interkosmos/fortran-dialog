! **********************************************************************
!
!                            HUNT THE WUMPUS
!
! A text-based adventure game from 1973: Find and kill the horrendous
! beast wumpus that lurks in a cave full of dangers. Originally written
! by Gregory Yob in BASIC. Ported to Fortran by the illustrious Philipp
! Engel.
!
! **********************************************************************
program wumpus
    use :: dialog
    implicit none

    character(len=*), parameter :: BACKTITLE = 'Hunt the Wumpus'
    character(len=*), parameter :: TITLE     = 'Welcome to Hunt the Wumpus'

    character(len=*), parameter :: NL  = new_line('a')
    character(len=*), parameter :: NL2 = NL // NL

    integer, parameter :: ACTION_EXIT = 1
    integer, parameter :: ACTION_HELP = 2

    integer, parameter :: MAXDIST = 5
    integer, parameter :: NROOMS  = 20

    integer, parameter :: ROOMS(NROOMS, 3) = reshape([ &
        2,  1,  2,  3, 1,  5,  6, 1,  8,  2, 10,  3, 12,  4,  6, 15,  7,  9, 11, 13, &
        5,  3,  4,  5, 4,  7,  8, 7, 10,  9, 12, 11, 14, 13, 14, 17, 16, 17, 18, 16, &
        8, 10, 12, 14, 6, 15, 17, 9, 18, 11, 19, 13, 20, 15, 16, 20, 18, 19, 20, 19  &
    ], [ 20, 3 ])

    type :: game_type
        integer :: hero            = 0
        integer :: wumpus          = 0
        integer :: bats(2)         = 0
        integer :: pits(2)         = 0
        integer :: narrows         = 5
        logical :: visited(NROOMS) = .false.
    end type game_type

    integer         :: state
    logical         :: next
    type(game_type) :: game

    call dialog_backend('dialog')

    do
        call intro(state)

        if (state == ACTION_HELP) then
            call help()
            cycle
        end if

        if (state == ACTION_EXIT) exit

        call init()

        do
            call turn(next)
            if (.not. next) exit
        end do
    end do
contains
    pure function itoa(i) result(a)
        !! Converts integer to character string of length 2.
        integer, intent(in) :: i
        character(len=2)    :: a

        write (a, '(i2)') i
    end function itoa

    integer function empty_room() result(room)
        !! Returns random empty room.
        real :: r

        do
            call random_number(r)
            room = 1 + int(r * 20)
            if (is_empty(room)) exit
        end do
    end function empty_room

    logical function is_empty(room)
        !! Returns `.true.` if given room is empty.
        integer, intent(in) :: room

        is_empty = .false.
        if (room == game%hero    .or. room == game%wumpus  .or. &
            room == game%bats(1) .or. room == game%bats(2) .or. &
            room == game%pits(1) .or. room == game%pits(2)) return
        is_empty = .true.
    end function is_empty

    integer function next_room(from) result(next)
        !! Returns random room adjacent to `from`.
        integer, intent(in)  :: from
        integer              :: i
        real                 :: r

        call random_number(r)
        i = 1 + int(r * 3)
        next = ROOMS(from, i)
    end function next_room

    subroutine help()
        !! Shows instructions.
        character(len=*), parameter :: Q = "'\''"
        character(len=*), parameter :: TEXT = &
            'The wumpus lives in a cave of 20 rooms. Each room has three '  // &
            'tunnels leading to other rooms. (Look at a dodecahedron to '   // &
            'see how this works -- if you don' // Q // 't know what a '     // &
            'dodecahedron is, ask someone.)' // NL2 // '\Z1Hazards\Zn'      // NL2 // &
            'Bottomless Pits - Two rooms have bottomless pits in them. '    // &
            'If you go there, you fall into the pit (and lose).'            // NL2 // &
            'Super Bats - Two other rooms have super bats. If you go '      // &
            'there, a bat grabs you and takes you to some other room at '   // &
            'random (which might be troublesome).' // NL2 // '\Z1Wumpus\Zn' // NL2 // &
            'The wumpus is not bothered by the hazards (he has sucker '     // &
            'feet and is too big for a bat to lift). Usually he is '        // &
            'asleep. Two things wake him up: Your entering his room '       // &
            'or your shooting an arrow.'                                    // NL2 // &
            'If the wumpus wakes, he moves (p=.75) one room or stays '      // &
            'still (p=.25). After that, if he is where you are, he eats '   // &
            'you up (and you lose).' // NL2 // '\Z1You\Zn'                  // NL2 // &
            'Each turn you may move or shoot a crooked arrow.'              // NL2 // &
            'Moving: You can go one room (thru one tunnel).'                // NL // &
            'Arrows: You have 5 arrows. you lose when you run out.'         // NL2 // &
            'Each arrow can go from 1 to 5 rooms. You aim by telling '      // &
            'the computer the rooms you want the arrow to go to. '          // &
            'If the arrow can' // Q // 't go that way (i.e. no tunnel) '    // &
            'it moves at random to the next room.'                          // NL2 // &
            'If the arrow hits the wumpus, you win.'                        // NL // &
            'If the arrow hits you, you lose.' // NL2 // '\Z1Warnings\Zn'   // NL2 // &
            'When you are one room away from wumpus or hazard, the '        // &
            'computer says:' // NL2 // 'Wumpus - "You smell a wumpus!"'     // NL // &
            'Bat    - "Bats nearby!"' // NL // 'Pit    - "You feel a draft!"'

        call dialog_msgbox(TEXT, 17, 60, colors=.true., no_collapse=.true., title=TITLE)
    end subroutine help

    subroutine init()
        !! Initialises the game.
        integer :: i

        game = game_type()

        game%hero   = empty_room()
        game%wumpus = empty_room()
        game%bats   = [ (empty_room(), i = 1, 2) ]
        game%pits   = [ (empty_room(), i = 1, 2) ]
    end subroutine init

    subroutine intro(state)
        !! Shows title screen.
        character(len=*), parameter :: TEXT = NL // repeat(' ', 18) // &
            'Creative Computing' // NL // repeat(' ', 16) // &
            'Morristown, New Jersey' // NL2 // &
            'A text-based adventure game from 1973: Find and kill the ' // &
            'horrendous beast wumpus that lurks in a cave full of dangers.' // NL2 // &
            'Originally written by Gregory Yob in BASIC. Ported to Fortran by ' // &
            'the illustrious Philipp Engel.' // NL2 // &
            'Select <Help> for the complete game instructions.'
        integer, intent(out) :: state

        state = dialog_yesno(TEXT, 17, 60, help_button=.true., no_collapse=.true., &
                             no_label='Quit', title=TITLE, yes_label='Start')
    end subroutine intro

    subroutine move(exit_stat)
        !! Moves player.
        integer, intent(out), optional :: exit_stat

        character(len=8)  :: input
        integer           :: i, room
        type(dialog_type) :: dialog
        type(menu_type)   :: menu(3)

        if (present(exit_stat)) exit_stat = DIALOG_NO

        do i = 1, size(menu)
            menu(i) = menu_type(achar(48 + i), 'Room ' // itoa(ROOMS(game%hero, i)))

            if (game%visited(ROOMS(game%hero, i))) &
                menu(i)%item = trim(menu(i)%item) // ' (visited)'
        end do

        call dialog_menu(dialog, 'Which room do you want to enter?', 10, 60, &
                         size(menu), menu, backtitle=BACKTITLE, no_tags=.true., &
                         title='Room ' // itoa(game%hero))
        call dialog_read(dialog, input)
        call dialog_close(dialog)

        if (len_trim(input) == 0) return
        if (present(exit_stat)) exit_stat = DIALOG_YES

        read (input, '(i2)') room
        game%hero = ROOMS(game%hero, room)
    end subroutine move

    subroutine shoot(exit_stat)
        !! Shoots into room.
        integer, intent(out), optional:: exit_stat

        character(len=16)  :: input
        character(len=256) :: text
        integer            :: dirs(MAXDIST)
        integer            :: i, last, n, next, stat
        real               :: r
        type(dialog_type)  :: dialog

        if (present(exit_stat)) exit_stat = DIALOG_NO

        text = 'Tunnels lead to ' // itoa(ROOMS(game%hero, 1)) // ', ' // &
               itoa(ROOMS(game%hero, 2)) // ' and ' // itoa(ROOMS(game%hero, 3)) // &
               '. Enter a list of rooms to shoot into (up to 5):'

        do
            call dialog_inputbox(dialog, text, 10, 60, backtitle=BACKTITLE, &
                                 title='Room ' // itoa(game%hero))
            call dialog_read(dialog, input)
            call dialog_close(dialog)
            if (len_trim(input) == 0) return

            dirs = huge(0)
            read (input, *, iostat=stat) dirs

            n = findloc(dirs, huge(0), 1) - 1
            if (n == -1) n = size(dirs)

            if (n == 0) then
                call dialog_msgbox('Invalid input, try again.', 6, 40, &
                                   backtitle=BACKTITLE, title='Invalid')
                cycle
            end if

            if (minval(dirs(1:n)) < 1 .or. maxval(dirs(1:n)) > NROOMS) then
                call dialog_msgbox('Invalid room, try again.', 6, 40, &
                                   backtitle=BACKTITLE, title='Invalid')
                cycle
            end if

            if (dirs(1) == game%hero) then
                call dialog_msgbox('You have to aim into an adjacent room, stupid.', 6, 40, &
                                   backtitle=BACKTITLE, title='Invalid')
                cycle
            end if

            exit
        end do

        if (present(exit_stat)) exit_stat = DIALOG_YES
        game%narrows = game%narrows - 1
        last = game%hero

        do i = 1, n
            next = dirs(i)
            if (next == 0) exit

            if (next == last .or. findloc(ROOMS(last, :), next, 1) == 0) then
                next = next_room(last)
            end if

            if (game%hero == game%wumpus) return

            if (next == game%hero) then
                game%hero = 0
                return
            end if

            if (next == game%wumpus) then
                game%wumpus = 0
                return
            end if

            last = next
        end do

        call random_number(r)
        if (r < 0.75) game%wumpus = next_room(game%wumpus)
    end subroutine shoot

    subroutine turn(next)
        !! Runs next turn.
        logical, intent(out)          :: next
        character(len=:), allocatable :: text
        integer                       :: answer, exit_stat, room
        integer                       :: i, n

        next = .false.
        game%visited(game%hero) = .true.

        if (game%wumpus == 0) then
            call dialog_msgbox(NL // 'Aha! You got the wumpus!', 7, 60, &
                               backtitle=BACKTITLE, title='Congratulations')
            return
        end if

        if (game%hero == game%wumpus) then
            call dialog_msgbox(NL // 'You find yourself face to face with the wumpus.' // NL // &
                               'It eats you whole.', 8, 60, backtitle=BACKTITLE, title='Wumpus')
            return
        end if

        if (game%hero == 0) then
            call dialog_msgbox(NL // 'Ouch! Arrow got you!', 7, 60, &
                               backtitle=BACKTITLE, title='Hit')
            return
        end if

        if (game%narrows < 1) then
            call dialog_msgbox(NL // 'You have run out of arrows!', 7, 60, &
                               backtitle=BACKTITLE, title='Arrows')
            return
        end if

        if (findloc(game%pits, game%hero, 1) > 0) then
            call dialog_msgbox(NL // 'Aaaaaaaaaaa! You have fallen into a bottomless pit.', 7, 60, &
                               backtitle=BACKTITLE, title='Pit')
            return
        end if

        if (findloc(game%bats, game%hero, 1) > 0) then
            call dialog_msgbox(NL // 'A bat has carried you into another empty room.', 7, 60, &
                               backtitle=BACKTITLE, title='Bat')
            game%hero = empty_room()
        end if

        text = 'You are in room ' // itoa(game%hero) // '.' // NL

        n = 0

        do i = 3, 1, -1
            room = ROOMS(game%hero, i)

            if (room == game%wumpus) then
                text = text // 'You smell a wumpus!' // NL
                n = n + 1
            end if

            if (findloc(game%bats, room, 1) > 0) then
                text = text // 'Bats nearby!' // NL
                n = n + 1
            end if

            if (findloc(game%pits, room, 1) > 0) then
                text = text // 'You feel a draft!' // NL
                n = n + 1
            end if
        end do

        text = text // 'You have ' // itoa(game%narrows) // ' arrows. Tunnels lead to ' // &
               itoa(ROOMS(game%hero, 1)) // ', ' // itoa(ROOMS(game%hero, 2)) // ' and ' // &
               itoa(ROOMS(game%hero, 3)) // '.'

        do
            answer = dialog_yesno(text, 6 + n, 60, backtitle=BACKTITLE, extra_button=.true., &
                                  extra_label='Shoot', no_label='Quit', &
                                  title='Room ' // itoa(game%hero), yes_label='Move')

            select case (answer)
                case (DIALOG_YES)
                    call move(exit_stat)
                    if (exit_stat == DIALOG_NO) cycle

                case (DIALOG_EXTRA)
                    call shoot(exit_stat)
                    if (exit_stat == DIALOG_NO) cycle

                case (DIALOG_NO, DIALOG_ESC)
                    call quit()
            end select

            exit
        end do

        next = .true.
    end subroutine turn

    subroutine quit()
        !! Exits the program.
        stop
    end subroutine quit
end program wumpus
