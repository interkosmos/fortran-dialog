# fortran-dialog
A work-in-progress wrapper module around [dialog](https://invisible-island.net/dialog/)
to create text user interfaces in Fortran 2008, similar to
[pythondialog](https://pythondialog.sourceforge.io/) for Python.

Packages of *dialog(1)* are available on most Unix-like operating systems. On
FreeBSD, an older version of `dialog` is already part of the base system.
Install the package `devel/cdialog` for an enhanced port:

```
# pkg install devel/cdialog
```

In Fortran, change the backend to `cdialog` before calling any dialog routines:

```fortran
    call dialog_set_binary('cdialog')
```

The basic widgets are compatible to [Xdialog](http://xdialog.free.fr/) as well.
Just set the binary to `Xdialog`.

## Coverage

| Widget         | Supported |
|----------------|-----------|
| `buildlist`    |           |
| `calendar`     | ✓         |
| `checklist`    |           |
| `dselect`      | ✓         |
| `editbox`      | ✓         |
| `form`         |           |
| `fselect`      | ✓         |
| `gauge`        | ✓         |
| `infobox`      | ✓         |
| `inputbox`     | ✓         |
| `inputmenu`    | ✓         |
| `menu`         | ✓         |
| `mixedform`    |           |
| `mixedgauge`   |           |
| `msgbox`       | ✓         |
| `pause`        | ✓         |
| `passwordbox`  | ✓         |
| `passwordform` |           |
| `prgbox`       | ✓         |
| `programbox`   | ✓         |
| `progressbox`  | ✓         |
| `radiolist`    |           |
| `rangebox`     | ✓         |
| `tailbox`      | ✓         |
| `tailboxbg`    |           |
| `textbox`      | ✓         |
| `timebox`      | ✓         |
| `treeview`     |           |
| `yesno`        | ✓         |

## Build Instructions

Download the *fortran-dialog* repository, and execute the Makefile:

```
$ git clone https://github.com/interkosmos/fortran-dialog
$ cd fortran-dialog/
$ make
```

If you prefer the Fortran Package Manager, run:

```
$ fpm build --profile=release
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

## Further Examples

More examples can be found in `examples/`:

* **hamurabi** is a port of the simulation game [Hamurabi](https://en.wikipedia.org/wiki/Hamurabi_(video_game)).
* **showcase** demonstrates all supported widget types.
* **wumpus** is a port of the game [Hunt the Wumpus](https://en.wikipedia.org/wiki/Hunt_the_Wumpus).

Build the programs with *make*:

```
$ make examples
```

## Widget Types

This section lists code snippets in Fortran for the supported *dialog(1)*
widgets.

### calendar

```fortran
    character(len=10) :: date
    type(dialog_type) :: dialog

    call dialog_calendar(dialog, 'Enter date:', 3, 42, &
                         day=1, month=1, year=2025, title='Calendar')
    call dialog_read(dialog, date)
    call dialog_close(dialog)

    print '("Date: ", a)', date
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
    type(dialog_type)  :: dialog

    call dialog_editbox(dialog, './examples/wumpus.f90', 18, 72, title='Edit Box')

    do
        call dialog_read(dialog, line)
        if (len_trim(line) == 0) exit
        print '(a)', trim(line)
    end do

    call dialog_close(dialog)
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

        call dialog_write(dialog, 'XXX' // NL)
        call dialog_write(dialog, a // NL)
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

    call dialog_inputbox(dialog, 'Enter your name:', 7, 32, &
                         'Alice', title='Name')

    call dialog_read(dialog, input)
    call dialog_close(dialog)

    print '("Input: ", a)', trim(input)
```

### inputmenu

```fortran
    character(len=32) :: renamed
    type(dialog_type) :: dialog
    type(menu_type)   :: menu(3)

    menu(1) = menu_type('item1', 'Item 1')
    menu(2) = menu_type('item2', 'Item 2')
    menu(3) = menu_type('item3', 'Item 3')

    call dialog_inputmenu(dialog, 'Input:', 16, 40, size(menu), menu, &
                          no_tags=.true., title='Input Menu')

    do
        call dialog_read(dialog, renamed)
        if (len_trim(renamed) == 0) exit
        print '(a)', trim(renamed)
    end do

    call dialog_close(dialog)
```

### menu

```fortran
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

    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_close(dialog)
```

### progressbox

```fortran
    character, parameter :: NL = new_line('a')

    call dialog_progressbox(dialog, 'Output:', 12, 32, title='Progress Box')

    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_write(dialog, 'zzz ... ' // NL)
    call dialog_close(dialog)
```

### rangebox

```fortran
    character(len=2)  :: range
    type(dialog_type) :: dialog

    call dialog_rangebox(dialog, 'Select range with PGUP/PGDOWN:', 7, 32, &
                         min_value=0, max_value=42, default_value=21, title='Demo')
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

    call dialog_inputbox(dialog, 'Enter time:', 7, 32, &
                         hour=12, minute=0, second=0, title='Name')

    call dialog_read(dialog, time)
    call dialog_close(dialog)

    print '("Time: ", a)', time
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
$ dialog --create-rc ~/.dialog.rc
```

Alter the settings to your liking. In `/usr/local/share/examples/dialog/`,
you find several pre-defined themes:

* `debian.rc`
* `slackware.rc`
* `sourcemage.rc`
* `suse.rc`
* `whiptail.rc`

Copy one of the widget styles to `~/.dialog.rc`.

## Compatiblity

* Single quotes should be avoided, as they have to be escaped as `"'\''"` in any
  text passed to *dialog(1)* from Fortran.
* Only the wrapper function `dialog_yesno()` and subroutines with optional dummy
  argument `exit_stat` return the exit status of *dialog(1)*.

## Licence

ISC
