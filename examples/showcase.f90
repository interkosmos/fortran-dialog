! **********************************************************************
! Menu-driven demo program that shows dialog boxes.
! **********************************************************************
program main
    use :: dialog
    implicit none
    character(len=*), parameter :: NL = new_line('a')

    character(len=16) :: selected
    type(dialog_type) :: dialog
    type(menu_type)   :: menu(20)

    menu = [ menu_type('calendar',    'Calendar'), &
             menu_type('dselect',     'Directory Select'), &
             menu_type('editbox',     'Edit Box'), &
             menu_type('fselect',     'File Select'), &
             menu_type('gauge',       'Gauge'), &
             menu_type('infobox',     'Info Box'), &
             menu_type('inputbox',    'Input Box'), &
             menu_type('inputmenu',   'Input Menu'), &
             menu_type('menu',        'Menu'), &
             menu_type('msgbox',      'Message Box'), &
             menu_type('passwordbox', 'Password Box'), &
             menu_type('pause',       'Pause'), &
             menu_type('prgbox',      'Prg Box'), &
             menu_type('programbox',  'Program Box'), &
             menu_type('progressbox', 'Progress Box'), &
             menu_type('rangebox',    'Range Box'), &
             menu_type('tailbox',     'Tail Box'), &
             menu_type('textbox',     'Text Box'), &
             menu_type('timebox',     'Time Box'), &
             menu_type('yesno',       'Yes/No') ]

    call dialog_backend('dialog')

    do
        call dialog_menu(dialog, NL // 'Welcome to the showcase!' // NL // NL // &
                         'Select widget to show:', 18, 52, size(menu), menu, &
                         backtitle='Dialog Showcase', cancel_label='Quit', &
                         no_tags=.true., ok_label='Show', title='Showcase Menu')

        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        if (len_trim(selected) == 0) exit

        select case (selected)
            case ('calendar')
                call widget_calendar()
            case ('dselect')
                call widget_dselect()
            case ('editbox')
                call widget_editbox()
            case ('fselect')
                call widget_fselect()
            case ('gauge')
                call widget_gauge()
            case ('infobox')
                call widget_infobox()
            case ('inputbox')
                call widget_inputbox()
            case ('inputmenu')
                call widget_inputmenu()
            case ('menu')
                call widget_menu()
            case ('msgbox')
                call widget_msgbox()
            case ('passwordbox')
                call widget_passwordbox()
            case ('pause')
                call widget_pause()
            case ('prgbox')
                call widget_prgbox()
            case ('programbox')
                call widget_programbox()
            case ('progressbox')
                call widget_progressbox()
            case ('rangebox')
                call widget_rangebox()
            case ('tailbox')
                call widget_tailbox()
            case ('textbox')
                call widget_textbox()
            case ('timebox')
                call widget_timebox()
            case ('yesno')
                call widget_yesno()
        end select
    end do
contains
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

    subroutine widget_calendar()
        character(len=10) :: date
        type(dialog_type) :: dialog

        call dialog_calendar(dialog, 'Enter date:', 3, 42, &
                             day=1, month=1, year=2025, title='Calendar')
        call dialog_read(dialog, date)
        call dialog_close(dialog)

        print '("Date: ", a)', date
    end subroutine widget_calendar

    subroutine widget_dselect()
        character(len=512) :: path
        type(dialog_type)  :: dialog

        call dialog_dselect(dialog, '/', 8, 72, title='Select Directory')
        call dialog_read(dialog, path)
        call dialog_close(dialog)

        print '("Directory: ", a)', trim(path)
    end subroutine widget_dselect

    subroutine widget_editbox()
        character(len=512) :: line
        logical            :: eof
        type(dialog_type)  :: dialog

        call dialog_editbox(dialog, './examples/wumpus.f90', 18, 72, title='Edit Box')

        do
            call dialog_read(dialog, line, eof)
            if (eof) exit
            print '(a)', trim(line)
        end do

        call dialog_close(dialog)
    end subroutine widget_editbox

    subroutine widget_fselect()
        character(len=512) :: path
        type(dialog_type)  :: dialog

        call dialog_fselect(dialog, '/', 8, 72, title='Select File')
        call dialog_read(dialog, path)
        call dialog_close(dialog)

        print '("File: ", a)', trim(path)
    end subroutine widget_fselect

    subroutine widget_gauge()
        integer           :: i
        type(dialog_type) :: dialog

        call dialog_gauge(dialog, 'Progress:', 12, 32, 0, title='Gauge')

        do i = 1, 100
            select case (i)
                case (:20)
                    call dialog_write(dialog, 'Validating ...' // NL)
                case (21:40)
                    call dialog_write(dialog, 'Updating ...' // NL)
                case (41:60)
                    call dialog_write(dialog, 'Doing more work ...' // NL)
                case (61:80)
                    call dialog_write(dialog, 'Just a few seconds ...' // NL)
                case (81:)
                    call dialog_write(dialog, 'Almost done ...' // NL)
            end select

            call dialog_write(dialog, 'XXX' // NL // itoa(i) // NL)
        end do

        call dialog_close(dialog)
    end subroutine widget_gauge

    subroutine widget_infobox()
        call dialog_infobox(NL // 'This is the info box widget.', 8, 36, &
                            title='Information', sleep=2)
    end subroutine widget_infobox

    subroutine widget_inputbox()
        character(len=32) :: name
        type(dialog_type) :: dialog

        call dialog_inputbox(dialog, 'Enter your name:', 7, 32, &
                             'Alice', title='Name')

        call dialog_read(dialog, name)
        call dialog_close(dialog)

        call dialog_msgbox('Hello, ' // trim(name) // '!', 6, 24)
    end subroutine widget_inputbox

    subroutine widget_inputmenu()
        character(len=32) :: renamed
        logical           :: eof
        type(dialog_type) :: dialog
        type(menu_type)   :: menu(3)

        menu(1) = menu_type('item1', 'Item 1')
        menu(2) = menu_type('item2', 'Item 2')
        menu(3) = menu_type('item3', 'Item 3')

        call dialog_inputmenu(dialog, 'Input:', 18, 40, size(menu), menu, &
                              no_tags=.true., title='Input Menu Demo')

        do
            call dialog_read(dialog, renamed, eof)
            if (eof) exit
            print '(a)', trim(renamed)
        end do

        call dialog_close(dialog)
    end subroutine widget_inputmenu

    subroutine widget_menu()
        character(len=8)  :: selection
        type(dialog_type) :: dialog
        type(menu_type)   :: menu(3)

        menu(1) = menu_type('item1', 'Item 1')
        menu(2) = menu_type('item2', 'Item 2')
        menu(3) = menu_type('item3', 'Item 3')

        call dialog_menu(dialog, 'Select an item:', 16, 40, size(menu), menu, &
                         no_tags=.true., title='Menu Demo')

        call dialog_read(dialog, selection)
        call dialog_close(dialog)

        print '("Selected item: ", a)', trim(selection)
    end subroutine widget_menu

    subroutine widget_msgbox()
        call dialog_msgbox('This is the message box widget.', 8, 36, title='Message')
    end subroutine widget_msgbox

    subroutine widget_passwordbox()
        character(len=32) :: password
        type(dialog_type) :: dialog

        call dialog_passwordbox(dialog, 'Enter password:', 7, 32, &
                                insecure=.true., title='Password')

        call dialog_read(dialog, password)
        call dialog_close(dialog)

        print '("Password: ", a)', trim(password)
    end subroutine widget_passwordbox

    subroutine widget_pause()
        integer :: stat

        call dialog_pause('System reboots in 30 seconds.', 8, 36, 30, &
                          title='Pause', exit_stat=stat)

        select case (stat)
            case (DIALOG_YES)
                print '("You pressed OK.")'
            case (DIALOG_NO)
                print '("You pressed Cancel.")'
            case default
                print '("You pressed Escape.")'
        end select
    end subroutine widget_pause

    subroutine widget_prgbox()
        call dialog_prgbox('Who is logged in?', 'w', 18, 72, title='Prg Box')
    end subroutine widget_prgbox

    subroutine widget_programbox()
        type(dialog_type) :: dialog

        call dialog_programbox(dialog, 'Output:', 12, 32, title='Program Box')

        call dialog_write(dialog, 'zzz ...' // NL)
        call dialog_write(dialog, 'zzz ...' // NL)
        call dialog_write(dialog, 'zzz ...' // NL)
        call dialog_close(dialog)
    end subroutine widget_programbox

    subroutine widget_progressbox()
        type(dialog_type) :: dialog
        integer           :: i

        call dialog_progressbox(dialog, 'Output:', 12, 32, title='Progress Box')

        do i = 1, 100000
            call dialog_write(dialog, 'zzz ...' // NL)
        end do

        call dialog_close(dialog)
    end subroutine widget_progressbox

    subroutine widget_rangebox()
        character(len=2)  :: range
        type(dialog_type) :: dialog

        call dialog_rangebox(dialog, 'Select range with PGUP/PGDOWN:', 7, 32, &
                             0, 42, 21, title='Demo')
        call dialog_read(dialog, range)
        call dialog_close(dialog)

        print '("Selected range: ", a)', range
    end subroutine widget_rangebox

    subroutine widget_tailbox()
        call dialog_tailbox('/var/log/messages', 18, 72, title='Tail Box')
    end subroutine widget_tailbox

    subroutine widget_textbox()
        call dialog_textbox('./examples/wumpus.f90', 18, 72, title='Text Box')
    end subroutine widget_textbox

    subroutine widget_timebox()
        character(len=32) :: time
        type(dialog_type) :: dialog

        call dialog_timebox(dialog, 'Enter time:', 3, 32, &
                            hour=16, minute=30, second=0, title='Time')

        call dialog_read(dialog, time)
        call dialog_close(dialog)

        call dialog_msgbox('Time: ' // trim(time), 6, 24)
    end subroutine widget_timebox

    subroutine widget_yesno()
        integer :: ans

        ans = dialog_yesno('Please press Yes or No!', 6, 36, title='Example')

        select case (ans)
            case (DIALOG_YES)
                print '("You pressed Yes.")'
            case (DIALOG_NO)
                print '("You pressed No.")'
            case default
                print '("You pressed Escape.")'
        end select
    end subroutine widget_yesno
end program main
