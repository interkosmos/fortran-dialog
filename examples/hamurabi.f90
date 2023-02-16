! **********************************************************************
!
!                               HAMURABI
!
! Hamurabi is management simulation in which the player governs the
! ancient city-state of Sumeria. The game was first developed under the
! name The Sumer Game by Doug Dyment in 1968.
!
! Converted from the original FOCAL program and modified for
! EduSystem 70 by David H. Ahl, Digital. Modified for 8k Microsoft BASIC
! by Peter Turnbull. Converted to Fortran by Philipp Engel.
!
! For the FORTRAN 77 source, see:
!
!   http://cyber.dabamos.de/programming/fortran/computer-games/hamurabi.html
!
! **********************************************************************
program hamurabi
    use :: dialog
    implicit none
    character(len=*), parameter :: NL        = new_line('a')
    character(len=*), parameter :: NL2       = NL // NL
    character(len=*), parameter :: BACKTITLE = 'Hamurabi'

    type :: game_type
        integer :: population  = 95   ! Size of the population.
        integer :: harvest     = 3000 ! Bushels harvested in one year.
        integer :: storage     = 2800 ! Number of bushels stored.
        integer :: yield       = 3    ! Yield of acres.
        integer :: nrats       = 0    ! Bushels eaten by rats.
        integer :: nacres      = 0    ! Acres owned by player.
        integer :: immigration = 5    ! Immigration per year.
        integer :: plague      = 1    ! Flag for horrible plague.
        integer :: ndead       = 0    ! Number of people who died.
        integer :: rel_dead    = 0    ! Percentage of people who died.
        integer :: price       = 0    ! Price per acre.
        integer :: nstarved    = 0    ! Number of people starved to death in one year.
        integer :: year        = 0    ! The current year.
    end type game_type

    type(game_type) :: game

    call random_seed()
    call dialog_backend('dialog')
    call title()
    call play(game)
contains
    integer function input(text)
        character(len=*), intent(in) :: text

        character(len=8)  :: buffer
        integer           :: stat
        type(dialog_type) :: dialog

        call dialog_inputbox(dialog, text, 8, 42, backtitle=BACKTITLE)
        call dialog_read(dialog, buffer)
        call dialog_close(dialog)

        read (buffer, '(i6)', iostat=stat) input
        if (stat /= 0 .or. input < 0) call resign()
    end function input

    pure function itoa(i) result(a)
        integer, intent(in)           :: i
        character(len=:), allocatable :: a

        integer :: n

        if (i == 0) then
            n = 1
        else
            n = floor(log10(real(abs(i))) + 1)
        end if

        if (i < 0) n = n + 1

        allocate (character(len=n) :: a)
        write (a, '(i0)') i
    end function itoa

    integer function feed(game)
        type(game_type), intent(inout) :: game

        do
            feed = input('How many of your ' // itoa(game%storage) // &
                         ' bushels do you wish to feed your people?')

            if (feed > game%storage) then
                call nobush(game)
                cycle
            end if

            exit
        end do

        game%storage = game%storage - feed
    end function feed

    integer function plant(game)
        type(game_type), intent(inout) :: game

        do
            plant = input('How many of your ' // itoa(game%nacres) // &
                          ' acres do you wish to plant with seed?')
            if (plant == 0) return

            ! Trying to plant more acres than the player owns?
            if (plant > game%nacres) then
                call noacre(game)
                cycle
            end if

            ! Enough grain for seed?
            if (int(plant / 2.0) > game%storage) then
                call nobush(game)
                cycle
            end if

            ! Enough people to tend the crops?
            if (plant >= 10 * game%population) then
                call dialog_msgbox('But you have only ' // itoa(game%population) // &
                                   ' people to tend the field!' // NL // &
                                   'Now then, ...', 6, 64, backtitle=BACKTITLE)
                cycle
            end if

            exit
        end do

        game%storage = game%storage - int(plant / 2.0)
    end function plant

    subroutine fink()
        call dialog_msgbox('Due to this extreme mismanagement you have not only ' // &
                           'been impeached and thrown out of office but you have ' // &
                           'also been declared national fink!!', 8, 64, &
                           backtitle=BACKTITLE)
        call quit()
    end subroutine fink

    subroutine noacre(game)
        type(game_type), intent(inout) :: game

        call dialog_msgbox('Think again. you own only ' // itoa(game%nacres) // &
                           ' acres.' // NL // 'Now then, ...', 6, 64, &
                           backtitle=BACKTITLE, title='Hamurabi:')
    end subroutine noacre

    subroutine nobush(game)
        type(game_type), intent(inout) :: game

        call dialog_msgbox('Think again. you have only ' // itoa(game%storage) // &
                           ' bushels of grain.' // NL // 'Now then, ...', 6, 64, &
                           backtitle=BACKTITLE, title='Hamurabi:')
    end subroutine nobush

    subroutine play(game)
        character(len=6), parameter    :: SP = ' '
        type(game_type), intent(inout) :: game

        character(len=:), allocatable :: report
        integer                       :: k, nfeed, nplanted, quota
        real                          :: r

        ! Initialise the game state.
        game%nrats  = game%harvest - game%storage
        game%nacres = game%harvest / game%yield

        ! The main loop.
        do
            game%year = game%year + 1
            game%population = game%population + game%immigration

            report = NL // 'I beg to report to you,' // NL2 // &
                     SP // 'In year ' // itoa(game%year) // ', ' // &
                     itoa(game%nstarved) // ' people starved, ' // &
                     itoa(game%immigration) // ' came to the city.' // NL2

            ! A plague strikes! half the population died.
            if (game%plague <= 0) then
                game%population = game%population / 2
                report = report // SP // 'A horrible plague struck! Half the people died.' // NL
            end if

            report = report // &
                     SP // 'Population is now ' // itoa(game%population) // '.' // NL2 // &
                     SP // 'The city now owns ' // itoa(game%nacres) // ' acres.' // NL // &
                     SP // 'You harvested ' // itoa(game%yield) // ' bushels per acre.' // NL // &
                     SP // 'The rats ate ' // itoa(game%nrats) // ' bushels.' // NL // &
                     SP // 'You now have ' // itoa(game%storage) // ' bushels in store.' // NL2

            ! Max. number of rounds reached: review performance and quit.
            if (game%year == 11) call review(game)

            ! Roll new price per acre.
            call random_number(r)
            game%price = int(10 * r) + 17

            ! Ask the player to buy/sell land.
            report = report // 'Land is trading at ' // itoa(game%price) // ' bushels per acre.'
            call dialog_msgbox(report, 18, 64, backtitle=BACKTITLE, no_collapse=.true., title='Hamurabi:')
            call trade(game)

            nfeed = feed(game)
            nplanted = plant(game)

            ! A bountiful harvest!
            call random_number(r)
            game%yield   = 1 + int(r * 5)
            game%harvest = nplanted * game%yield
            game%nrats   = 0

            ! Rats are running wild.
            if (int(game%yield / 2.0) == game%yield / 2) then
                call random_number(r)
                k = 1 + int(r * 5)
                game%nrats = game%storage / k
            end if

            game%storage = game%storage - game%nrats + game%harvest

            ! Let's have some babies. (Actually, it's immigration.)
            call random_number(r)
            k = 1 + int(r * 5)
            game%immigration = int(k * (20 * game%nacres + game%storage) / &
                                   game%population / 100 + 1)

            ! Horrors, a 15% chance of plague.
            call random_number(r)
            game%plague = int(10 * (2 * r - 0.3))
            quota = nfeed / 20

            ! Either a new year, or impeachment if too many people starved.
            if (game%population < quota) then
                game%nstarved = 0
            else
                game%nstarved = game%population - quota

                if (game%nstarved > 0.45 * game%population) then
                    call dialog_msgbox('You starved ' // itoa(game%nstarved) // &
                                       ' people in one year!!', 6, 64, backtitle=BACKTITLE)
                    call fink()
                end if

                game%rel_dead = ((game%year - 1) * game%rel_dead + game%nstarved * &
                                 100 / game%population) / game%year
                game%population = quota
                game%ndead = game%ndead + game%nstarved
            end if
        end do
    end subroutine play

    subroutine resign()
        call dialog_msgbox('I cannot do what you wish.' // NL // &
                           'Get yourself another steward!!', 6, 64, title='Hamurabi:')
        call quit()
    end subroutine resign

    subroutine review(game)
        type(game_type), intent(inout) :: game

        character(len=:), allocatable :: report
        integer                       :: land, nenemies
        real                          :: r

        land = game%nacres / game%population

        report = 'In your 10-year term of office, ' // itoa(game%rel_dead) // &
                 ' percent of the population starved per year on the average, ' // &
                 'i.e. a total of ' // itoa(game%ndead) // ' people died!!' // NL2 // &
                 'You started with 10 acres per person and ended with ' // &
                 itoa(land) // ' acres per person.' // NL2

        if (game%rel_dead > 33 .or. land < 7) then
            call dialog_msgbox(report, 16, 64, backtitle=BACKTITLE, &
                               ok_label='Quit', title='Review')
            call fink()
        end if

        if (game%rel_dead > 10 .or. land < 9) then
            report = report // 'Your heavy-handed performance smacks of Nero and ' // &
                     'Ivan IV. The people (remaining) find you an unpleasant ruler, ' // &
                     'and, frankly, hate your guts!!'
        else if (game%rel_dead > 3 .or. land < 10) then
            call random_number(r)
            nenemies = int(game%population * 0.8 * r)
            report = report // 'Your performance could have been somewhat better, ' // &
                     'but really wasn''t too bad at all. ' // itoa(nenemies) // &
                     ' people would dearly like to see you assassinated but we all ' // &
                     'have our trivial problems.'
        else
            report = report // 'A fantastic performance!! Charlemange, Disraeli, ' // &
                     'and Jefferson combined could not have done better!'
        end if

        call dialog_msgbox(report, 16, 64, backtitle=BACKTITLE, &
                           ok_label='Quit', title='Review')
        call quit()
    end subroutine review

    subroutine title()
        character(len=*), parameter :: TEXT = NL // repeat(' ', 20) // &
            'Creative Computing' // NL // repeat(' ', 18) // &
            'Morristown, New Jersey' // NL2 // &
            'Try your hand at governing ancient Sumeria ' // &
            'for a ten-year term of office.' // NL2 // &
            'The game was first developed under the name The Sumer Game by ' // &
            'Doug Dyment in 1968. Converted from the original FOCAL program ' // &
            'and modified for EduSystem 70 by David H. Ahl, Digital. ' // &
            'Modified for 8k Microsoft BASIC by Peter Turnbull. Converted ' // &
            'to Fortran by Philipp Engel.'
        integer :: answer

        answer = dialog_yesno(TEXT, 17, 64, no_collapse=.true., no_label='Quit', &
                              title='Hamurabi', yes_label='Start')
        if (answer /= DIALOG_YES) call quit()
    end subroutine title

    subroutine trade(game)
        type(game_type), intent(inout) :: game
        integer                        :: nacres

        do
            nacres = input('How many acres do you wish to buy?')

            if (game%price * nacres > game%storage) then
                call nobush(game)
                cycle
            end if

            if (nacres > 0) then
                game%nacres  = game%nacres + nacres
                game%storage = game%storage - game%price * nacres
                return
            end if

            exit
        end do

        do
            nacres = input('How many acres do you wish to sell?')

            if (nacres >= game%nacres) then
                call noacre(game)
                cycle
            end if

            if (nacres > 0) then
                game%nacres = game%nacres - nacres
                game%storage = game%storage + game%price * nacres
                return
            end if

            exit
        end do
    end subroutine trade

    subroutine quit()
        call dialog_infobox('So long for now.', 3, 24)
        stop
    end subroutine quit
end program hamurabi
