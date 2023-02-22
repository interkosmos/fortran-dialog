! **********************************************************************
! Menu-driven demo program that shows dialog boxes.
! **********************************************************************
program main
    use :: dialog
    implicit none
    character(len=*), parameter :: NL = new_line('a')

    character(len=16) :: selected
    integer           :: stat
    type(dialog_type) :: dialog
    type(menu_type)   :: menu(28)

    menu = [ menu_type('buildlist',    'Build List'), &
             menu_type('calendar',     'Calendar'), &
             menu_type('checklist',    'Check List'), &
             menu_type('dselect',      'Directory Select'), &
             menu_type('editbox',      'Edit Box'), &
             menu_type('form',         'Form'), &
             menu_type('fselect',      'File Select'), &
             menu_type('gauge',        'Gauge'), &
             menu_type('infobox',      'Info Box'), &
             menu_type('inputbox',     'Input Box'), &
             menu_type('inputmenu',    'Input Menu'), &
             menu_type('menu',         'Menu'), &
             menu_type('mixedform',    'Mixed Form'), &
             menu_type('mixedgauge',   'Mixed Gauge'), &
             menu_type('msgbox',       'Message Box'), &
             menu_type('passwordbox',  'Password Box'), &
             menu_type('passwordform', 'Password Form'), &
             menu_type('pause',        'Pause'), &
             menu_type('prgbox',       'Prg Box'), &
             menu_type('programbox',   'Program Box'), &
             menu_type('progressbox',  'Progress Box'), &
             menu_type('radiolist',    'Radio List'), &
             menu_type('rangebox',     'Range Box'), &
             menu_type('tailbox',      'Tail Box'), &
             menu_type('textbox',      'Text Box'), &
             menu_type('timebox',      'Time Box'), &
             menu_type('treeview',     'Tree View'), &
             menu_type('yesno',        'Yes/No') ]

    call dialog_backend('cdialog')

    do
        call dialog_menu(dialog, NL // 'Welcome to the showcase!' // NL // NL // &
                         'Select widget to show:', 18, 52, size(menu), menu, &
                         backtitle='Dialog Showcase', cancel_label='Quit', &
                         no_tags=.true., no_shadow=.true., ok_label='Show', &
                         title='Showcase Menu')
        call dialog_read(dialog, selected)
        call dialog_close(dialog, stat)

        if (stat == 256 .or. len_trim(selected) == 0) exit

        select case (selected)
            case ('buildlist')
                call widget_buildlist()
            case ('calendar')
                call widget_calendar()
            case ('checklist')
                call widget_checklist()
            case ('dselect')
                call widget_dselect()
            case ('editbox')
                call widget_editbox()
            case ('form')
                call widget_form()
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
            case ('mixedform')
                call widget_mixedform()
            case ('mixedgauge')
                call widget_mixedgauge()
            case ('msgbox')
                call widget_msgbox()
            case ('passwordbox')
                call widget_passwordbox()
            case ('passwordform')
                call widget_passwordform()
            case ('pause')
                call widget_pause()
            case ('prgbox')
                call widget_prgbox()
            case ('programbox')
                call widget_programbox()
            case ('progressbox')
                call widget_progressbox()
            case ('radiolist')
                call widget_radiolist()
            case ('rangebox')
                call widget_rangebox()
            case ('tailbox')
                call widget_tailbox()
            case ('textbox')
                call widget_textbox()
            case ('timebox')
                call widget_timebox()
            case ('treeview')
                call widget_treeview()
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
            if (i < 0) n = n + 1
        end if

        allocate (character(len=n) :: a)
        write (a, '(i0)') i
    end function itoa

    subroutine widget_buildlist()
        character(len=32) :: selected
        type(dialog_type) :: dialog
        type(list_type)   :: list(3)

        list(1) = list_type('item1', 'List Item 1', 'on')
        list(2) = list_type('item2', 'List Item 2')
        list(3) = list_type('item3', 'List Item 3')

        call dialog_buildlist(dialog, 'Select items:', 16, 40, 5, list, &
                              title='Build List')
        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        print '("Selected items: ", a)', trim(selected)
    end subroutine widget_buildlist

    subroutine widget_calendar()
        character(len=12) :: date
        type(dialog_type) :: dialog

        call dialog_calendar(dialog, 'Enter date:', 3, 42, &
                             day=1, month=1, year=2025, title='Calendar')
        call dialog_read(dialog, date)
        call dialog_close(dialog)

        print '("Date: ", a)', date
    end subroutine widget_calendar

    subroutine widget_checklist()
        character(len=32) :: selected
        type(dialog_type) :: dialog
        type(list_type)   :: list(3)

        list(1) = list_type('item1', 'List Item 1', 'on')
        list(2) = list_type('item2', 'List Item 2')
        list(3) = list_type('item3', 'List Item 3')

        call dialog_checklist(dialog, 'Select items:', 16, 40, 5, list, &
                              title='Check List')
        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        print '("Selected items: ", a)', trim(selected)
    end subroutine widget_checklist

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

    subroutine widget_form()
        character(len=32) :: user, shell, group
        type(dialog_type) :: dialog
        type(form_type)   :: form(3)

        form(1) = form_type('User:',  1, 1, 'user',    1, 10, 10, 0)
        form(2) = form_type('Shell:', 2, 1, '/bin/sh', 2, 10, 10, 0)
        form(3) = form_type('Group:', 3, 1, 'wheel',   3, 10, 10, 0)

        call dialog_form(dialog, 'Set user data:', 16, 40, 5, form, &
                         ok_label='Submit', title='Form')
        call dialog_read(dialog, user)
        call dialog_read(dialog, shell)
        call dialog_read(dialog, group)
        call dialog_close(dialog)

        print '("User:  ", a)', trim(user)
        print '("Shell: ", a)', trim(shell)
        print '("Group: ", a)', trim(group)
    end subroutine widget_form

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
        character(len=8)  :: selected
        type(dialog_type) :: dialog
        type(menu_type)   :: menu(3)

        menu(1) = menu_type('item1', 'Item 1')
        menu(2) = menu_type('item2', 'Item 2')
        menu(3) = menu_type('item3', 'Item 3')

        call dialog_menu(dialog, 'Select an item:', 16, 40, size(menu), menu, &
                         no_tags=.true., title='Menu Demo')
        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        print '("Selected item: ", a)', trim(selected)
    end subroutine widget_menu

    subroutine widget_mixedform()
        character(len=32) :: user, shell, group
        type(dialog_type) :: dialog
        type(form_type)   :: form(3)

        form(1) = form_type('User:',  1, 1, 'user',    1, 10, 10, 0, 2)
        form(2) = form_type('Shell:', 2, 1, '/bin/sh', 2, 10, 10, 0, 0)
        form(3) = form_type('Group:', 3, 1, 'wheel',   3, 10, 10, 0, 0)

        call dialog_mixedform(dialog, 'Set user data:', 16, 40, 5, form, &
                              ok_label='Submit', title='Mixed Form')
        call dialog_read(dialog, user)
        call dialog_read(dialog, shell)
        call dialog_read(dialog, group)
        call dialog_close(dialog)

        print '("User:  ", a)', trim(user)
        print '("Shell: ", a)', trim(shell)
        print '("Group: ", a)', trim(group)
    end subroutine widget_mixedform

    subroutine widget_mixedgauge()
        integer          :: i
        type(gauge_type) :: gauge(10)

        gauge(1) = gauge_type('Process one',   '0')
        gauge(2) = gauge_type('Process two',   '1')
        gauge(3) = gauge_type('Process three', '2')
        gauge(4) = gauge_type('Process four',  '3')
        gauge(5) = gauge_type('',              '8')
        gauge(6) = gauge_type('Process five',  '5')
        gauge(7) = gauge_type('Process six',   '6')
        gauge(8) = gauge_type('Process seven', '7')
        gauge(9) = gauge_type('Process eight', '4')

        do i = 0, 100, 20
            gauge(10) = gauge_type('Process nine', '-' // itoa(i))
            call dialog_mixedgauge('Progress:', 20, 64, 33, gauge, title='Mixed Gauge')
            call sleep(1)
        end do
    end subroutine widget_mixedgauge

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

    subroutine widget_passwordform()
        character(len=32) :: uuid, password
        type(dialog_type) :: dialog
        type(form_type)   :: form(2)

        form(1) = form_type('UUID:',     1, 1, '12345',  1, 10, 10, 0)
        form(2) = form_type('Password:', 2, 1, 'secret', 2, 10, 10, 0)

        call dialog_passwordform(dialog, 'Set values:', 12, 40, 3, form, insecure=.true., &
                                 ok_label='Submit', title='Password Form')
        call dialog_read(dialog, uuid)
        call dialog_read(dialog, password)
        call dialog_close(dialog)

        print '("UUID:     ", a)', trim(uuid)
        print '("Password: ", a)', trim(password)
    end subroutine widget_passwordform

    subroutine widget_pause()
        integer :: stat

        call dialog_pause('System reboots in 10 seconds.', 8, 36, 10, &
                          title='Pause', exit_stat=stat)

        select case (stat)
            case (DIALOG_YES)
                print '("Reboot selected.")'
            case (DIALOG_NO)
                print '("Reboot canceled.")'
            case default
                print '("Escape pressed.")'
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

    subroutine widget_radiolist()
        character(len=32) :: selected
        type(dialog_type) :: dialog
        type(list_type)   :: list(3)

        list(1) = list_type('item1', 'List Item 1', 'on')
        list(2) = list_type('item2', 'List Item 2')
        list(3) = list_type('item3', 'List Item 3')

        call dialog_radiolist(dialog, 'Select items:', 16, 40, 5, list, &
                              title='Radio List')
        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        print '("Selected item: ", a)', trim(selected)
    end subroutine widget_radiolist

    subroutine widget_rangebox()
        character(len=3)  :: range
        type(dialog_type) :: dialog

        call dialog_rangebox(dialog, 'Select range with PGUP/PGDOWN:', 10, 52, &
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

    subroutine widget_treeview()
        character(len=32) :: selected
        type(dialog_type) :: dialog
        type(tree_type)   :: tree(9)

        tree(1) = tree_type('tag1', 'one',   'off', 0)
        tree(2) = tree_type('tag2', 'two',   'off', 1)
        tree(3) = tree_type('tag3', 'three', 'on',  2)
        tree(4) = tree_type('tag4', 'four',  'off', 1)
        tree(5) = tree_type('tag5', 'five',  'off', 2)
        tree(6) = tree_type('tag6', 'six',   'off', 3)
        tree(7) = tree_type('tag7', 'seven', 'off', 3)
        tree(8) = tree_type('tag8', 'eight', 'off', 4)
        tree(9) = tree_type('tag9', 'nine',  'off', 1)

        call dialog_treeview(dialog, 'Select item:', 0, 0, 0, tree, title='Tree View')
        call dialog_read(dialog, selected)
        call dialog_close(dialog)

        print '("Selected: ", a)', trim(selected)
    end subroutine widget_treeview

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
