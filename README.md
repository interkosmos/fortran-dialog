# fortran-dialog
A work-in-progress wrapper module around [dialog](https://invisible-island.net/dialog/)
to create text user interfaces in Fortran 2008, similar to
[pythondialog](https://pythondialog.sourceforge.io/) for Python.

Packages of *dialog(1)* are available on most Unix-like operating systems. On
FreeBSD, an older version of dialog is already part of the base system. Install
the package `devel/cdialog` for an enhanced port:

```
# pkg install devel/cdialog
```

Add an alias to your global `profile`, or set the backend to `cdialog` before
calling any dialog routines from Fortran:

```fortran
call dialog_backend('cdialog')
```

The basic widgets are compatible to [Xdialog](http://xdialog.free.fr/) as well.
Just set the backend to `Xdialog`.

## Coverage

| Widget         | Supported |
|----------------|-----------|
| `buildlist`    | ✓         |
| `calendar`     | ✓         |
| `checklist`    | ✓         |
| `dselect`      | ✓         |
| `editbox`      | ✓         |
| `form`         | ✓         |
| `fselect`      | ✓         |
| `gauge`        | ✓         |
| `infobox`      | ✓         |
| `inputbox`     | ✓         |
| `inputmenu`    | ✓         |
| `menu`         | ✓         |
| `mixedform`    | ✓         |
| `mixedgauge`   | ✓         |
| `msgbox`       | ✓         |
| `pause`        | ✓         |
| `passwordbox`  | ✓         |
| `passwordform` | ✓         |
| `prgbox`       | ✓         |
| `programbox`   | ✓         |
| `progressbox`  | ✓         |
| `radiolist`    | ✓         |
| `rangebox`     | ✓         |
| `tailbox`      | ✓         |
| `tailboxbg`    |           |
| `textbox`      | ✓         |
| `timebox`      | ✓         |
| `treeview`     | ✓         |
| `yesno`        | ✓         |

## Build Instructions

Download the *fortran-dialog* repository, and execute the Makefile:

```
$ git clone https://github.com/interkosmos/fortran-dialog
$ cd fortran-dialog/
$ make
```

If you prefer the [Fortran Package Manager](https://github.com/fortran-lang/fpm),
run:

```
$ fpm build --profile=release
```

You can add *fortran-dialog* as a dependency to your `fpm.toml`:

```toml
[dependencies]
fortran-dialog = { git = "https://github.com/interkosmos/fortran-dialog.git" }
```

## Example

The following example just shows a message box in terminal:

```fortran
! example.f90
program main
    use :: dialog

    call dialog_msgbox('This is the message box widget.', 10, 30)
end program main
```

Link the example against `libfortran-dialog.a`:

```
$ gfortran -o example example.f90 libfortran-dialog.a
$ ./example
```

For a graphical message box, write instead:

```fortran
! example.f90
program main
    use :: dialog

    call dialog_backend('Xdialog')
    call dialog_msgbox('This is the message box widget.', 10, 30)
end program main
```

## Further Examples

More examples can be found in `examples/`:

* **hamurabi** is a port of the simulation game [Hamurabi](https://en.wikipedia.org/wiki/Hamurabi_(video_game)).
* **showcase** demonstrates all supported widget types.
* **wumpus** is a port of the game [Hunt the Wumpus](https://en.wikipedia.org/wiki/Hunt_the_Wumpus).

Build the programs with *make*:

```
$ make examples
```

## Widgets

This section lists code snippets in Fortran for the supported *dialog(1)*
widgets. See the official website for
[screen shots](https://invisible-island.net/dialog/dialog-figures.html).

### buildlist

```fortran
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
```

### calendar

```fortran
character(len=10) :: date
type(dialog_type) :: dialog

call dialog_calendar(dialog, 'Enter date:', 3, 42, day=1, month=1, year=2025, &
                     title='Calendar')
call dialog_read(dialog, date)
call dialog_close(dialog)

print '("Date: ", a)', date
```

### checklist

```fortran
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
```

### dselect

```fortran
character(len=512) :: path
type(dialog_type)  :: dialog

call dialog_dselect(dialog, '/', 18, 72, title='Select Directory')
call dialog_read(dialog, path)
call dialog_close(dialog)

print '("Directory: ", a)', trim(path)
```

### editbox

```fortran
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
```

### form

```fortran
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
```

### fselect

```fortran
character(len=512) :: path
type(dialog_type)  :: dialog

call dialog_fselect(dialog, '/', 18, 72, title='Select File')
call dialog_read(dialog, path)
call dialog_close(dialog)

print '("File: ", a)', trim(path)
```

### gauge

```fortran
character, parameter :: NL = new_line('a')

character(len=3)  :: a
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

    write (a, '(i0)') i
    call dialog_write(dialog, 'XXX' // NL // a // NL)
end do

call dialog_close(dialog)
```

### infobox

```fortran
call dialog_infobox(new_line('a') // 'This is the info box widget.', &
                    8, 36, title='Information', sleep=2)
```

### inputbox

```fortran
character(len=32) :: input
type(dialog_type) :: dialog

call dialog_inputbox(dialog, 'Enter your name:', 7, 32, 'Alice', title='Name')
call dialog_read(dialog, input)
call dialog_close(dialog)

print '("Input: ", a)', trim(input)
```

### inputmenu

```fortran
character(len=32) :: renamed
logical           :: eof
type(dialog_type) :: dialog
type(menu_type)   :: menu(3)

menu(1) = menu_type('item1', 'Item 1')
menu(2) = menu_type('item2', 'Item 2')
menu(3) = menu_type('item3', 'Item 3')

call dialog_inputmenu(dialog, 'Input:', 16, 40, size(menu), menu, &
                      no_tags=.true., title='Input Menu')

do
    call dialog_read(dialog, renamed, eof)
    if (eof) exit
    print '(a)', trim(renamed)
end do

call dialog_close(dialog)
```

### menu

```fortran
character(len=32) :: selected
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
```

### mixedform

```fortran
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
```

### mixedgauge

```fortran
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
```

### msgbox

```fortran
call dialog_msgbox('This is the message box widget.', 8, 36, &
                   backtitle='msgbox', title='Message')
```

### passwordbox

```fortran
character(len=32) :: password
type(dialog_type) :: dialog

call dialog_passwordbox(dialog, 'Enter password:', 7, 32, &
                        insecure=.true., title='Password')
call dialog_read(dialog, password)
call dialog_close(dialog)

print '("Password: ", a)', trim(password)
```

### passwordform

```fortran
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
```

### pause

```fortran
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
```

### prgbox

```fortran
call dialog_prgbox('Uptime:', 'uptime', 8, 64, title='Prg Box')
```

### programbox

```fortran
character, parameter :: NL = new_line('a')

call dialog_programbox(dialog, 'Output:', 12, 32, title='Program Box')
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_close(dialog)
```

### progressbox

```fortran
character, parameter :: NL = new_line('a')

call dialog_progressbox(dialog, 'Output:', 12, 32, title='Progress Box')
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_write(dialog, 'zzz ...' // NL)
call dialog_close(dialog)
```

### radiolist

```fortran
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
```

### rangebox

```fortran
character(len=2)  :: range
type(dialog_type) :: dialog

call dialog_rangebox(dialog, 'Select range with PGUP/PGDOWN:', 7, 32, min_value=0, &
                     max_value=42, default_value=21, title='Range Box')
call dialog_read(dialog, range)
call dialog_close(dialog)

print '("Selected range: ", a)', range
```

### tailbox

```fortran
call dialog_tailbox('/var/log/messages', 18, 72, title='Tail Box')
```

### textbox

```fortran
call dialog_textbox('./examples/wumpus.f90', 18, 72, title='Text Box')
```

### timebox

```fortran
character(len=8)  :: time
type(dialog_type) :: dialog

call dialog_inputbox(dialog, 'Enter time:', 7, 32, hour=12, minute=0, second=0, &
                     title='Time')
call dialog_read(dialog, time)
call dialog_close(dialog)

print '("Time: ", a)', time
```

### treeview

```fortran
character(len=32) :: selected
type(dialog_type) :: dialog
type(tree_type)   :: tree(4)

tree(1) = tree_type('tag1', 'one',   'off', 0)
tree(2) = tree_type('tag2', 'two',   'off', 1)
tree(3) = tree_type('tag3', 'three', 'on',  2)
tree(4) = tree_type('tag4', 'four',  'off', 1)

call dialog_treeview(dialog, 'Select item:', 0, 0, 0, tree, title='Tree View')
call dialog_read(dialog, selected)
call dialog_close(dialog)

print '("Selected: ", a)', trim(selected)
```

### yesno

```fortran
integer :: answer

answer = dialog_yesno('Please press Yes or No!', 6, 30, title='Example')

select case (answer)
    case (DIALOG_YES)
        print '("You pressed Yes.")'
    case (DIALOG_NO)
        print '("You pressed No.")'
    case default
        print '("You pressed Escape.")'
end select
```

## Themes

You can create a new *dialog(1)* theme via:

```
$ dialog --create-rc ~/.dialogrc
```

Alter the settings to your liking. In `/usr/local/share/examples/dialog/`,
you find several pre-defined themes:

* `debian.rc`
* `slackware.rc`
* `sourcemage.rc`
* `suse.rc`
* `whiptail.rc`

Copy one of the widget styles to `~/.dialogrc`.

## Compatiblity

* Single quotes should be avoided, as they have to be escaped as `"'\''"` in any
  text passed to *dialog(1)* from Fortran.
* Only the wrapper function `dialog_yesno()` and subroutines with optional dummy
  argument `exit_stat` return the exit status of *dialog(1)*.

## Licence

ISC
