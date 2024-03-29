! dialog.f90
!
! Author:  Philipp Engel
! Licence: ISC
module dialog
    use, intrinsic :: iso_c_binding
    implicit none
    private

    ! Default dialog binary name.
    character(len=256), save :: dialog_executable = 'dialog'

    ! Public parameters.
    integer, parameter, public :: DIALOG_ERROR   = -1
    integer, parameter, public :: DIALOG_YES     = 0
    integer, parameter, public :: DIALOG_NO      = 1
    integer, parameter, public :: DIALOG_CANCEL  = 1
    integer, parameter, public :: DIALOG_HELP    = 2
    integer, parameter, public :: DIALOG_EXTRA   = 3
    integer, parameter, public :: DIALOG_TIMEOUT = 5
    integer, parameter, public :: DIALOG_ESC     = 255

    ! Widgets.
    integer, parameter :: WIDGET_NONE         = 0
    integer, parameter :: WIDGET_BUILDLIST    = 1
    integer, parameter :: WIDGET_CALENDAR     = 2
    integer, parameter :: WIDGET_CHECKLIST    = 3
    integer, parameter :: WIDGET_DSELECT      = 4
    integer, parameter :: WIDGET_EDITBOX      = 5
    integer, parameter :: WIDGET_FORM         = 6
    integer, parameter :: WIDGET_FSELECT      = 7
    integer, parameter :: WIDGET_GAUGE        = 8
    integer, parameter :: WIDGET_INFOBOX      = 9
    integer, parameter :: WIDGET_INPUTBOX     = 10
    integer, parameter :: WIDGET_INPUTMENU    = 11
    integer, parameter :: WIDGET_MENU         = 12
    integer, parameter :: WIDGET_MIXEDFORM    = 13
    integer, parameter :: WIDGET_MIXEDGAUGE   = 14
    integer, parameter :: WIDGET_MSGBOX       = 15
    integer, parameter :: WIDGET_PASSWORDBOX  = 16
    integer, parameter :: WIDGET_PASSWORDFORM = 17
    integer, parameter :: WIDGET_PAUSE        = 18
    integer, parameter :: WIDGET_PRGBOX       = 19
    integer, parameter :: WIDGET_PROGRAMBOX   = 20
    integer, parameter :: WIDGET_PROGRESSBOX  = 21
    integer, parameter :: WIDGET_RADIOLIST    = 22
    integer, parameter :: WIDGET_RANGEBOX     = 23
    integer, parameter :: WIDGET_TAILBOX      = 24
    integer, parameter :: WIDGET_TAILBOXBG    = 25
    integer, parameter :: WIDGET_TEXTBOX      = 26
    integer, parameter :: WIDGET_TIMEBOX      = 27
    integer, parameter :: WIDGET_TREEVIEW     = 28
    integer, parameter :: WIDGET_YESNO        = 29
    integer, parameter :: NWIDGETS            = 29

    character(len=12), parameter :: WIDGET_NAMES(NWIDGETS) = [ character(len=12) :: &
        'buildlist', 'calendar', 'checklist', 'dselect', 'editbox', 'form', &
        'fselect', 'gauge', 'infobox', 'inputbox', 'inputmenu', 'menu', &
        'mixedform', 'mixedgauge', 'msgbox', 'passwordbox', 'passwordform', &
        'pause', 'prgbox', 'programbox', 'progressbox', 'radiolist', 'rangebox', &
        'tailbox', 'tailboxbg', 'textbox', 'timebox', 'treeview', 'yesno' &
    ]

    ! Common options.
    integer, parameter :: C_ASCII_LINES      =  1
    integer, parameter :: C_ASPECT           =  2
    integer, parameter :: C_BACKTITLE        =  3
    integer, parameter :: C_BEGIN            =  4
    integer, parameter :: C_CANCEL_LABEL     =  5
    integer, parameter :: C_CLEAR            =  6
    integer, parameter :: C_COLORS           =  7
    integer, parameter :: C_COLUMN_SEPARATOR =  8
    integer, parameter :: C_CR_WRAP          =  9
    integer, parameter :: C_CURSOR_OFF_LABEL = 10
    integer, parameter :: C_DATE_FORMAT      = 11
    integer, parameter :: C_DEFAULT_BUTTON   = 12
    integer, parameter :: C_DEFAULT_ITEM     = 13
    integer, parameter :: C_DEFAULT_NO       = 14
    integer, parameter :: C_ERASE_ON_EXIT    = 15
    integer, parameter :: C_EXIT_LABEL       = 16
    integer, parameter :: C_EXTRA_BUTTON     = 17
    integer, parameter :: C_EXTRA_LABEL      = 18
    integer, parameter :: C_HELP_BUTTON      = 19
    integer, parameter :: C_HELP_LABEL       = 20
    integer, parameter :: C_HELP_STATUS      = 21
    integer, parameter :: C_HELP_TAGS        = 22
    integer, parameter :: C_HFILE            = 23
    integer, parameter :: C_HLINE            = 24
    integer, parameter :: C_IGNORE           = 25
    integer, parameter :: C_INPUT_FD         = 26
    integer, parameter :: C_INSECURE         = 27
    integer, parameter :: C_ISO_WEEK         = 28
    integer, parameter :: C_ITEM_HELP        = 29
    integer, parameter :: C_KEEP_TITLE       = 30
    integer, parameter :: C_KEEP_WINDOW      = 31
    integer, parameter :: C_LAST_KEY         = 32
    integer, parameter :: C_MAX_INPUT        = 33
    integer, parameter :: C_NO_CANCEL        = 34
    integer, parameter :: C_NO_COLLAPSE      = 35
    integer, parameter :: C_NO_HOT_LIST      = 36
    integer, parameter :: C_NO_ITEMS         = 37
    integer, parameter :: C_NO_KILL          = 38
    integer, parameter :: C_NO_LABEL         = 39
    integer, parameter :: C_NO_LINES         = 40
    integer, parameter :: C_NO_MOUSE         = 41
    integer, parameter :: C_NO_NL_EXPAND     = 42
    integer, parameter :: C_NO_OK            = 43
    integer, parameter :: C_NO_SHADOW        = 44
    integer, parameter :: C_NO_TAGS          = 45
    integer, parameter :: C_OK_LABEL         = 46
    integer, parameter :: C_OUTPUT_FD        = 47
    integer, parameter :: C_QUOTED           = 48
    integer, parameter :: C_REORDER          = 49
    integer, parameter :: C_SCROLLBAR        = 50
    integer, parameter :: C_SEPARATE_OUTPUT  = 51
    integer, parameter :: C_SEPARATE_WIDGET  = 52
    integer, parameter :: C_SEPARATOR        = 53
    integer, parameter :: C_SINGLE_QUOTED    = 54
    integer, parameter :: C_SLEEP            = 55
    integer, parameter :: C_STDERR           = 56
    integer, parameter :: C_TAB_CORRECT      = 57
    integer, parameter :: C_TAB_LEN          = 58
    integer, parameter :: C_TIMEOUT          = 59
    integer, parameter :: C_TIME_FORMAT      = 60
    integer, parameter :: C_TITLE            = 61
    integer, parameter :: C_TRACE            = 62
    integer, parameter :: C_TRIM             = 63
    integer, parameter :: C_VISIT_ITEMS      = 64
    integer, parameter :: C_WEEK_START       = 65
    integer, parameter :: C_YES_LABEL        = 66
    integer, parameter :: NCOMMON            = 66

    type, public :: form_type
        character(len=80)  :: label   = ' '  !! Label string.
        integer            :: label_y = 0    !! Label Y position.
        integer            :: label_x = 0    !! Label X Position.
        character(len=256) :: item    = ' '  !! Field value.
        integer            :: item_y  = 0    !! Field Y position.
        integer            :: item_x  = 0    !! Field X position.
        integer            :: flen    = 0    !! Field length.
        integer            :: ilen    = 0    !! Input length.
        integer            :: itype   = 0    !! Input type (1: hidden, 2: read-only).
    end type form_type

    type, public :: gauge_type
        character(len=80)  :: tag  = ' '     !! Gauge item tag.
        character(len=256) :: item = ' '     !! Gauge item progress.
    end type gauge_type

    type, public :: list_type
        character(len=80)  :: tag    = ' '   !! List item tag.
        character(len=256) :: item   = ' '   !! List item title.
        character(len=3)   :: status = 'off' !! List item status (`on` or `off`).
    end type list_type

    type, public :: menu_type
        character(len=80)  :: tag  = ' '     !! Menu item tag.
        character(len=256) :: item = ' '     !! Menu item title.
    end type menu_type

    type, public :: tree_type
        character(len=80)  :: tag    = ' '   !! Tree item tag.
        character(len=256) :: item   = ' '   !! Tree item title.
        character(len=3)   :: status = 'off' !! Tree item status (`on` or `off`).
        integer            :: depth  = 0     !! Tree item depth.
    end type tree_type

    integer, parameter :: PIPE_RDONLY = 0
    integer, parameter :: PIPE_WRONLY = 1

    type :: pipe_type
        integer     :: mode = PIPE_RDONLY !! Read or write mode.
        type(c_ptr) :: ptr  = c_null_ptr  !! Pointer to pipe.
    end type pipe_type

    type :: common_type
        integer            :: aspect           = 0
        character(len=256) :: backtitle        = ' '
        integer            :: begin_x          = 0
        integer            :: begin_y          = 0
        character(len=32)  :: cancel_label     = ' '
        character          :: column_separator = ' '
        character(len=32)  :: date_format      = ' ' ! strftime
        character(len=8)   :: default_button   = ' ' ! ok, yes, cancel, no, help, extra
        character(len=32)  :: default_item     = ' '
        character(len=32)  :: exit_label       = ' '
        character(len=32)  :: extra_label      = ' '
        character(len=32)  :: help_label       = ' '
        character(len=256) :: hfile            = ' '
        character(len=256) :: hline            = ' '
        integer            :: input_fd         = 0
        integer            :: max_input        = 0
        character(len=32)  :: no_label         = ' '
        character(len=32)  :: ok_label         = ' '
        integer            :: output_fd        = 0
        character          :: separator        = ' '
        character          :: separate_widget  = ' '
        integer            :: sleep            = 0   ! in seconds
        integer            :: tab_len          = 0
        character(len=32)  :: time_format      = ' ' ! strftime
        integer            :: timeout          = 0
        character(len=256) :: title            = ' '
        character(len=256) :: trace            = ' '
        character(len=8)   :: week_start       = ' '
        character(len=32)  :: yes_label        = ' '
    end type common_type

    type :: argument_type
        character(len=2048)       :: text          = ' '
        integer                   :: height        = 0
        integer                   :: width         = 0
        character(len=256)        :: command       = ' '
        character(len=256)        :: init          = ' '
        integer                   :: min_value     = 0
        integer                   :: max_value     = 0
        integer                   :: default_value = 0
        integer                   :: percent       = 0
        integer                   :: seconds       = 0
        integer                   :: day           = 0
        integer                   :: month         = 0
        integer                   :: year          = 0
        integer                   :: hour          = 0
        integer                   :: minute        = 0
        integer                   :: second        = 0
        integer                   :: form_height   = 0
        integer                   :: list_height   = 0
        integer                   :: menu_height   = 0
        integer                   :: tree_height   = 0
        type(form_type),  pointer :: form(:)       => null()
        type(gauge_type), pointer :: gauge(:)      => null()
        type(list_type),  pointer :: list(:)       => null()
        type(menu_type),  pointer :: menu(:)       => null()
        type(tree_type),  pointer :: tree(:)       => null()
    end type argument_type

    type, public :: dialog_type
        private
        integer             :: widget           = WIDGET_NONE
        logical             :: options(NCOMMON) = .false.
        character(len=4096) :: cmd              = ' '
        type(common_type)   :: common
        type(argument_type) :: argument
        type(pipe_type)     :: pipe
    end type dialog_type

    public :: dialog_backend
    public :: dialog_close
    public :: dialog_read
    public :: dialog_write

    public :: dialog_buildlist
    public :: dialog_calendar
    public :: dialog_checklist
    public :: dialog_dselect
    public :: dialog_editbox
    public :: dialog_form
    public :: dialog_fselect
    public :: dialog_gauge
    public :: dialog_infobox
    public :: dialog_inputbox
    public :: dialog_inputmenu
    public :: dialog_menu
    public :: dialog_mixedform
    public :: dialog_mixedgauge
    public :: dialog_msgbox
    public :: dialog_passwordbox
    public :: dialog_passwordform
    public :: dialog_pause
    public :: dialog_prgbox
    public :: dialog_programbox
    public :: dialog_progressbox
    public :: dialog_radiolist
    public :: dialog_rangebox
    public :: dialog_tailbox
    public :: dialog_textbox
    public :: dialog_timebox
    public :: dialog_treeview
    public :: dialog_yesno

    private :: dialog_command
    private :: dialog_create
    private :: dialog_exec
    private :: dialog_open

    private :: dialog_set_ascii_lines
    private :: dialog_set_aspect
    private :: dialog_set_backtitle
    private :: dialog_set_begin
    private :: dialog_set_cancel_label
    private :: dialog_set_clear
    private :: dialog_set_colors
    private :: dialog_set_column_separator
    private :: dialog_set_cr_wrap
    private :: dialog_set_cursor_off_label
    private :: dialog_set_date_format
    private :: dialog_set_default_button
    private :: dialog_set_default_item
    private :: dialog_set_default_no
    private :: dialog_set_erase_on_exit
    private :: dialog_set_exit_label
    private :: dialog_set_extra_button
    private :: dialog_set_extra_label
    private :: dialog_set_help_button
    private :: dialog_set_help_label
    private :: dialog_set_help_status
    private :: dialog_set_help_tags
    private :: dialog_set_hfile
    private :: dialog_set_hline
    private :: dialog_set_ignore
    private :: dialog_set_input_fd
    private :: dialog_set_insecure
    private :: dialog_set_iso_week
    private :: dialog_set_item_help
    private :: dialog_set_keep_title
    private :: dialog_set_keep_window
    private :: dialog_set_last_key
    private :: dialog_set_max_input
    private :: dialog_set_no_cancel
    private :: dialog_set_no_collapse
    private :: dialog_set_no_hot_list
    private :: dialog_set_no_items
    private :: dialog_set_no_kill
    private :: dialog_set_no_label
    private :: dialog_set_no_lines
    private :: dialog_set_no_mouse
    private :: dialog_set_no_nl_expand
    private :: dialog_set_no_ok
    private :: dialog_set_no_shadow
    private :: dialog_set_no_tags
    private :: dialog_set_ok_label
    private :: dialog_set_output_fd
    private :: dialog_set_quoted
    private :: dialog_set_reorder
    private :: dialog_set_scrollbar
    private :: dialog_set_separate_output
    private :: dialog_set_separate_widget
    private :: dialog_set_separator
    private :: dialog_set_single_quoted
    private :: dialog_set_sleep
    private :: dialog_set_stderr
    private :: dialog_set_tab_correct
    private :: dialog_set_tab_len
    private :: dialog_set_timeout
    private :: dialog_set_time_format
    private :: dialog_set_title
    private :: dialog_set_trace
    private :: dialog_set_trim
    private :: dialog_set_visit_items
    private :: dialog_set_week_start
    private :: dialog_set_yes_label

    interface
        ! char *fgets(char *str, int size, FILE *stream)
        function c_fgets(str, sz, stream) bind(c, name='fgets')
            import :: c_char, c_int, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: str
            integer(kind=c_int),    intent(in), value :: sz
            type(c_ptr),            intent(in), value :: stream
            type(c_ptr)                               :: c_fgets
        end function c_fgets

        ! int fputs(const char *str, FILE *stream)
        function c_fputs(str, stream) bind(c, name='fputs')
            import :: c_char, c_int, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: str
            type(c_ptr),            intent(in), value :: stream
            integer(kind=c_int)                       :: c_fputs
        end function c_fputs

        ! int pclose(FILE *stream)
        function c_pclose(stream) bind(c, name='pclose')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: stream
            integer(kind=c_int)            :: c_pclose
        end function c_pclose

        ! FILE *popen(const char *command, const char *type)
        function c_popen(command, type) bind(c, name='popen')
            import :: c_char, c_ptr
            implicit none
            character(kind=c_char), intent(in) :: command
            character(kind=c_char), intent(in) :: type
            type(c_ptr)                        :: c_popen
        end function c_popen
    end interface
contains
    ! ******************************************************************
    ! PUBLIC PROCEDURES
    ! ******************************************************************
    subroutine dialog_backend(backend)
        character(len=*), intent(in) :: backend

        if (len_trim(backend) > 0) dialog_executable = adjustl(backend)
    end subroutine dialog_backend

    subroutine dialog_close(dialog, exit_stat)
        type(dialog_type), intent(inout)         :: dialog
        integer,           intent(out), optional :: exit_stat
        integer                                  :: rc

        if (present(exit_stat)) exit_stat = -1
        if (.not. c_associated(dialog%pipe%ptr)) return

        rc = c_pclose(dialog%pipe%ptr)
        if (present(exit_stat)) exit_stat = rc

        dialog%pipe%ptr = c_null_ptr

        nullify (dialog%argument%form)
        nullify (dialog%argument%gauge)
        nullify (dialog%argument%list)
        nullify (dialog%argument%menu)
        nullify (dialog%argument%tree)
    end subroutine dialog_close

    subroutine dialog_read(dialog, str, eof)
        type(dialog_type), intent(inout)         :: dialog
        character(len=*),  intent(inout)         :: str
        logical,           intent(out), optional :: eof

        character(len=len(str)) :: buf
        integer                 :: i, j
        type(c_ptr)             :: ptr

        if (present(eof)) eof = .true.
        if (.not. c_associated(dialog%pipe%ptr)) return
        if (dialog%pipe%mode /= PIPE_RDONLY) return

        str = ' '
        buf = repeat(c_null_char, len(buf))
        ptr = c_fgets(buf, len(buf), dialog%pipe%ptr)

        if (.not. c_associated(ptr)) return
        if (present(eof)) eof = .false.

        i = index(buf, c_null_char)
        if (i == 1) return
        if (i == 0) i = len(buf)
        j = i - 1
        if (buf(j:j) == c_new_line .and. j == 1) return
        if (buf(j:j) == c_new_line) j = j - 1
        str(1:j) = buf(1:j)
    end subroutine dialog_read

    subroutine dialog_write(dialog, str)
        type(dialog_type), intent(inout) :: dialog
        character(len=*),  intent(in)    :: str
        integer                          :: rc

        if (.not. c_associated(dialog%pipe%ptr)) return
        if (dialog%pipe%mode /= PIPE_WRONLY) return
        rc = c_fputs(trim(str) // c_null_char, dialog%pipe%ptr)
    end subroutine dialog_write

    ! ******************************************************************
    ! WIDGET PROCEDURES
    ! ******************************************************************
    subroutine dialog_buildlist(dialog, text, height, width, list_height, list, &
            ascii_lines, aspect, backtitle, cancel_label, clear, colors, cr_wrap, &
            ok_label, no_mouse, no_shadow, no_tags, reorder, single_quoted, timeout, &
            title, visit_items)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: list_height
        type(list_type), target, intent(inout)        :: list(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        logical,                 intent(in), optional :: cr_wrap
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        logical,                 intent(in), optional :: reorder
        logical,                 intent(in), optional :: single_quoted
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title
        logical,                 intent(in), optional :: visit_items

        call dialog_create(dialog, WIDGET_BUILDLIST, text, height, width)

        dialog%argument%list_height = list_height
        dialog%argument%list => list

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_reorder(dialog, reorder)
        call dialog_set_single_quoted(dialog, single_quoted)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)
        call dialog_set_visit_items(dialog, visit_items)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_buildlist

    subroutine dialog_calendar(dialog, text, height, width, day, month, year, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, date_format, iso_week, no_mouse, &
            no_shadow, ok_label, timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        integer,           intent(in)           :: day
        integer,           intent(in)           :: month
        integer,           intent(in)           :: year
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        character(len=*),  intent(in), optional :: date_format
        logical,           intent(in), optional :: iso_week
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_CALENDAR, text, height, width)

        dialog%argument%day   = day
        dialog%argument%month = month
        dialog%argument%year  = year

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_date_format(dialog, date_format)
        call dialog_set_iso_week(dialog, iso_week)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_calendar

    subroutine dialog_checklist(dialog, text, height, width, list_height, list, &
            ascii_lines, aspect, backtitle, cancel_label, clear, colors, column_separator, &
            cr_wrap, default_item, ok_label, no_hot_list, no_mouse, no_shadow, no_tags, &
            single_quoted, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: list_height
        type(list_type), target, intent(inout)        :: list(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        character,               intent(in), optional :: column_separator
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: no_hot_list
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        logical,                 intent(in), optional :: single_quoted
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_CHECKLIST, text, height, width)

        dialog%argument%list_height = list_height
        dialog%argument%list => list

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_column_separator(dialog, column_separator)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_no_hot_list(dialog, no_hot_list)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_single_quoted(dialog, single_quoted)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_checklist

    subroutine dialog_dselect(dialog, path, height, width, ascii_lines, aspect, &
            backtitle, cancel_label, clear, colors, no_mouse, no_shadow, ok_label, &
            timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: path
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_DSELECT, path, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_dselect

    subroutine dialog_editbox(dialog, path, height, width, ascii_lines, aspect, &
            backtitle, cancel_label, clear, colors, no_mouse, no_shadow, ok_label, &
            timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: path
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_EDITBOX, path, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_editbox

    subroutine dialog_form(dialog, text, height, width, form_height, form, &
            ascii_lines, aspect, backtitle, cancel_label, clear, colors, cr_wrap, &
            default_item, no_mouse, no_shadow, ok_label, no_tags, single_quoted, &
            timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: form_height
        type(form_type), target, intent(inout)        :: form(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        logical,                 intent(in), optional :: single_quoted
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_FORM, text, height, width)

        dialog%argument%form_height = form_height
        dialog%argument%form => form

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_single_quoted(dialog, single_quoted)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_form

    subroutine dialog_fselect(dialog, path, height, width, ascii_lines, aspect, &
            backtitle, cancel_label, clear, colors, no_mouse, no_shadow, ok_label, &
            timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: path
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_FSELECT, path, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_fselect

    subroutine dialog_gauge(dialog, text, height, width, percent, ascii_lines, &
            aspect, backtitle, clear, colors, no_mouse, no_shadow, ok_label, timeout, &
            title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        integer,           intent(in)           :: percent
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_GAUGE, text, height, width)

        dialog%argument%percent = min(100, max(0, percent))

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_WRONLY)
    end subroutine dialog_gauge

    subroutine dialog_inputbox(dialog, text, height, width, init, ascii_lines, aspect, &
            backtitle, cancel_label, clear, colors, no_mouse, no_shadow, ok_label, &
            timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        character(len=*),  intent(in), optional :: init
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_INPUTBOX, text, height, width)

        dialog%argument%init = init

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_inputbox

    subroutine dialog_infobox(text, height, width, ascii_lines, aspect, backtitle, &
            colors, cr_wrap, no_collapse, no_mouse, no_shadow, title, sleep, exit_stat)
        character(len=*), intent(in)            :: text
        integer,          intent(in)            :: height
        integer,          intent(in)            :: width
        logical,          intent(in),  optional :: ascii_lines
        integer,          intent(in),  optional :: aspect
        character(len=*), intent(in),  optional :: backtitle
        logical,          intent(in),  optional :: colors
        logical,          intent(in),  optional :: cr_wrap
        logical,          intent(in),  optional :: no_collapse
        logical,          intent(in),  optional :: no_mouse
        logical,          intent(in),  optional :: no_shadow
        character(len=*), intent(in),  optional :: title
        integer,          intent(in),  optional :: sleep
        integer,          intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_INFOBOX, text, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_title(dialog, title)
        call dialog_set_sleep(dialog, sleep)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_infobox

    subroutine dialog_inputmenu(dialog, text, height, width, menu_height, menu, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, column_separator, cr_wrap, &
            default_item, no_hot_list, no_mouse, no_shadow, no_tags, ok_label, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: menu_height
        type(menu_type), target, intent(inout)        :: menu(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        character,               intent(in), optional :: column_separator
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: no_hot_list
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_INPUTMENU, text, height, width)

        dialog%argument%menu_height = menu_height
        dialog%argument%menu => menu

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_column_separator(dialog, column_separator)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_no_hot_list(dialog, no_hot_list)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_inputmenu

    subroutine dialog_menu(dialog, text, height, width, menu_height, menu, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, column_separator, cr_wrap, &
            default_item, help_button, hfile, hline, no_hot_list, no_mouse, no_shadow, &
            no_tags, ok_label, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: menu_height
        type(menu_type), target, intent(inout)        :: menu(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        character,               intent(in), optional :: column_separator
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: help_button
        character(len=*),        intent(in), optional :: hfile
        character(len=*),        intent(in), optional :: hline
        logical,                 intent(in), optional :: no_hot_list
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_MENU, text, height, width)

        dialog%argument%menu_height = menu_height
        dialog%argument%menu => menu

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_column_separator(dialog, column_separator)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_help_button(dialog, help_button)
        call dialog_set_hfile(dialog, hfile)
        call dialog_set_hline(dialog, hline)
        call dialog_set_no_hot_list(dialog, no_hot_list)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_menu

    subroutine dialog_mixedform(dialog, text, height, width, form_height, form, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, cr_wrap, default_item, no_mouse, &
            no_shadow, no_tags, ok_label, single_quoted, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: form_height
        type(form_type), target, intent(inout)        :: form(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        logical,                 intent(in), optional :: single_quoted
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_MIXEDFORM, text, height, width)

        dialog%argument%form_height = form_height
        dialog%argument%form => form

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_single_quoted(dialog, single_quoted)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_mixedform

    subroutine dialog_mixedgauge(text, height, width, percent, gauge, ascii_lines, aspect, &
            backtitle, clear, colors, no_mouse, no_shadow, ok_label, timeout, title, &
            exit_stat)
        character(len=*),         intent(in)            :: text
        integer,                  intent(in)            :: height
        integer,                  intent(in)            :: width
        integer,                  intent(in)            :: percent
        type(gauge_type), target, intent(inout)         :: gauge(:)
        logical,                  intent(in),  optional :: ascii_lines
        integer,                  intent(in),  optional :: aspect
        character(len=*),         intent(in),  optional :: backtitle
        logical,                  intent(in),  optional :: clear
        logical,                  intent(in),  optional :: colors
        logical,                  intent(in),  optional :: no_mouse
        logical,                  intent(in),  optional :: no_shadow
        character(len=*),         intent(in),  optional :: ok_label
        integer,                  intent(in),  optional :: timeout
        character(len=*),         intent(in),  optional :: title
        integer,                  intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_MIXEDGAUGE, text, height, width)

        dialog%argument%percent = min(100, max(0, percent))
        dialog%argument%gauge => gauge

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_mixedgauge

    subroutine dialog_msgbox(text, height, width, ascii_lines, aspect, backtitle, &
            cancel_label, clear, colors, cr_wrap, hfile, hline, no_collapse, no_mouse, &
            no_shadow, ok_label, timeout, title, exit_stat)
        character(len=*), intent(in)            :: text
        integer,          intent(in)            :: height
        integer,          intent(in)            :: width
        logical,          intent(in),  optional :: ascii_lines
        integer,          intent(in),  optional :: aspect
        character(len=*), intent(in),  optional :: backtitle
        character(len=*), intent(in),  optional :: cancel_label
        logical,          intent(in),  optional :: clear
        logical,          intent(in),  optional :: colors
        logical,          intent(in),  optional :: cr_wrap
        character(len=*), intent(in),  optional :: hfile
        character(len=*), intent(in),  optional :: hline
        logical,          intent(in),  optional :: no_collapse
        logical,          intent(in),  optional :: no_mouse
        logical,          intent(in),  optional :: no_shadow
        character(len=*), intent(in),  optional :: ok_label
        integer,          intent(in),  optional :: timeout
        character(len=*), intent(in),  optional :: title
        integer,          intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_MSGBOX, text, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_hfile(dialog, hfile)
        call dialog_set_hline(dialog, hline)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_msgbox

    subroutine dialog_passwordbox(dialog, text, height, width, init, ascii_lines, aspect, &
            backtitle, cancel_label, clear, colors, insecure, no_mouse, no_shadow, ok_label, &
            timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        character(len=*),  intent(in), optional :: init
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: insecure
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_PASSWORDBOX, text, height, width)

        dialog%argument%init = init

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_insecure(dialog, insecure)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_passwordbox

    subroutine dialog_passwordform(dialog, text, height, width, form_height, form, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, cr_wrap, default_item, insecure, &
            no_mouse, no_shadow, no_tags, ok_label, single_quoted, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: form_height
        type(form_type), target, intent(inout)        :: form(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        logical,                 intent(in), optional :: cr_wrap
        character(len=*),        intent(in), optional :: default_item
        logical,                 intent(in), optional :: insecure
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        logical,                 intent(in), optional :: single_quoted
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_PASSWORDFORM, text, height, width)

        dialog%argument%form_height = form_height
        dialog%argument%form => form

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_item(dialog, default_item)
        call dialog_set_insecure(dialog, insecure)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_single_quoted(dialog, single_quoted)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_passwordform

    subroutine dialog_pause(text, height, width, seconds, ascii_lines, aspect, backtitle, &
            colors, cr_wrap, no_collapse, no_mouse, no_shadow, title, sleep, exit_stat)
        character(len=*), intent(in)            :: text
        integer,          intent(in)            :: height
        integer,          intent(in)            :: width
        integer,          intent(in)            :: seconds
        logical,          intent(in),  optional :: ascii_lines
        integer,          intent(in),  optional :: aspect
        character(len=*), intent(in),  optional :: backtitle
        logical,          intent(in),  optional :: colors
        logical,          intent(in),  optional :: cr_wrap
        logical,          intent(in),  optional :: no_collapse
        logical,          intent(in),  optional :: no_mouse
        logical,          intent(in),  optional :: no_shadow
        character(len=*), intent(in),  optional :: title
        integer,          intent(in),  optional :: sleep
        integer,          intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_PAUSE, text, height, width)

        dialog%argument%seconds = max(0, seconds)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_title(dialog, title)
        call dialog_set_sleep(dialog, sleep)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_pause

    subroutine dialog_prgbox(text, command, height, width, ascii_lines, aspect, backtitle, &
            clear, colors, no_mouse, no_shadow, ok_label, timeout, title)
        character(len=*),  intent(in)           :: text
        character(len=*),  intent(in)           :: command
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_PRGBOX, text, height, width)

        dialog%argument%command = command

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_exec(dialog)
    end subroutine dialog_prgbox

    subroutine dialog_programbox(dialog, text, height, width, ascii_lines, aspect, backtitle, &
            clear, colors, no_mouse, no_shadow, ok_label, timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_PROGRAMBOX, text, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_WRONLY)
    end subroutine dialog_programbox

    subroutine dialog_progressbox(dialog, text, height, width, ascii_lines, aspect, &
            backtitle, clear, colors, no_mouse, no_shadow, timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_PROGRESSBOX, text, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_WRONLY)
    end subroutine dialog_progressbox

    subroutine dialog_radiolist(dialog, text, height, width, list_height, list, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, column_separator, cr_wrap, &
            no_mouse, no_shadow, no_tags, ok_label, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: list_height
        type(list_type), target, intent(inout)        :: list(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        character,               intent(in), optional :: column_separator
        logical,                 intent(in), optional :: cr_wrap
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_RADIOLIST, text, height, width)

        dialog%argument%list_height = list_height
        dialog%argument%list => list

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_column_separator(dialog, column_separator)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_radiolist

    subroutine dialog_rangebox(dialog, text, height, width, min_value, max_value, default_value, &
            ascii_lines, aspect, backtitle, cancel_label, clear, colors, no_mouse, no_shadow, &
            ok_label, timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        integer,           intent(in)           :: min_value
        integer,           intent(in)           :: max_value
        integer,           intent(in)           :: default_value
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_RANGEBOX, text, height, width)

        dialog%argument%min_value = min_value
        dialog%argument%max_value = max_value
        dialog%argument%default_value = default_value

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_rangebox

    subroutine dialog_tailbox(file, height, width, ascii_lines, aspect, backtitle, colors, &
            cr_wrap, no_collapse, no_mouse, no_shadow, title, sleep, exit_stat)
        character(len=*), intent(in)            :: file
        integer,          intent(in)            :: height
        integer,          intent(in)            :: width
        logical,          intent(in),  optional :: ascii_lines
        integer,          intent(in),  optional :: aspect
        character(len=*), intent(in),  optional :: backtitle
        logical,          intent(in),  optional :: colors
        logical,          intent(in),  optional :: cr_wrap
        logical,          intent(in),  optional :: no_collapse
        logical,          intent(in),  optional :: no_mouse
        logical,          intent(in),  optional :: no_shadow
        character(len=*), intent(in),  optional :: title
        integer,          intent(in),  optional :: sleep
        integer,          intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_TAILBOX, file, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_title(dialog, title)
        call dialog_set_sleep(dialog, sleep)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_tailbox

    subroutine dialog_textbox(file, height, width, ascii_lines, aspect, backtitle, colors, &
            cr_wrap, no_collapse, no_mouse, no_shadow, title, sleep, exit_stat)
        character(len=*), intent(in)            :: file
        integer,          intent(in)            :: height
        integer,          intent(in)            :: width
        logical,          intent(in),  optional :: ascii_lines
        integer,          intent(in),  optional :: aspect
        character(len=*), intent(in),  optional :: backtitle
        logical,          intent(in),  optional :: colors
        logical,          intent(in),  optional :: cr_wrap
        logical,          intent(in),  optional :: no_collapse
        logical,          intent(in),  optional :: no_mouse
        logical,          intent(in),  optional :: no_shadow
        character(len=*), intent(in),  optional :: title
        integer,          intent(in),  optional :: sleep
        integer,          intent(out), optional :: exit_stat

        integer           :: rc
        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_TEXTBOX, file, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_title(dialog, title)
        call dialog_set_sleep(dialog, sleep)

        call dialog_exec(dialog, rc)
        if (present(exit_stat)) exit_stat = rc
    end subroutine dialog_textbox

    subroutine dialog_timebox(dialog, text, height, width, hour, minute, second, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, no_mouse, no_shadow, ok_label, &
            time_format, timeout, title)
        type(dialog_type), intent(out)          :: dialog
        character(len=*),  intent(in)           :: text
        integer,           intent(in)           :: height
        integer,           intent(in)           :: width
        integer,           intent(in)           :: hour
        integer,           intent(in)           :: minute
        integer,           intent(in)           :: second
        logical,           intent(in), optional :: ascii_lines
        integer,           intent(in), optional :: aspect
        character(len=*),  intent(in), optional :: backtitle
        character(len=*),  intent(in), optional :: cancel_label
        logical,           intent(in), optional :: clear
        logical,           intent(in), optional :: colors
        logical,           intent(in), optional :: no_mouse
        logical,           intent(in), optional :: no_shadow
        character(len=*),  intent(in), optional :: ok_label
        character(len=*),  intent(in), optional :: time_format
        integer,           intent(in), optional :: timeout
        character(len=*),  intent(in), optional :: title

        call dialog_create(dialog, WIDGET_TIMEBOX, text, height, width)

        dialog%argument%hour   = hour
        dialog%argument%minute = minute
        dialog%argument%second = second

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_time_format(dialog, time_format)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_timebox

    subroutine dialog_treeview(dialog, text, height, width, tree_height, tree, ascii_lines, &
            aspect, backtitle, cancel_label, clear, colors, cr_wrap, no_mouse, no_shadow, &
            no_tags, ok_label, timeout, title)
        type(dialog_type),       intent(out)          :: dialog
        character(len=*),        intent(in)           :: text
        integer,                 intent(in)           :: height
        integer,                 intent(in)           :: width
        integer,                 intent(in)           :: tree_height
        type(tree_type), target, intent(inout)        :: tree(:)
        logical,                 intent(in), optional :: ascii_lines
        integer,                 intent(in), optional :: aspect
        character(len=*),        intent(in), optional :: backtitle
        character(len=*),        intent(in), optional :: cancel_label
        logical,                 intent(in), optional :: clear
        logical,                 intent(in), optional :: colors
        logical,                 intent(in), optional :: cr_wrap
        logical,                 intent(in), optional :: no_mouse
        logical,                 intent(in), optional :: no_shadow
        logical,                 intent(in), optional :: no_tags
        character(len=*),        intent(in), optional :: ok_label
        integer,                 intent(in), optional :: timeout
        character(len=*),        intent(in), optional :: title

        call dialog_create(dialog, WIDGET_TREEVIEW, text, height, width)

        dialog%argument%tree_height = tree_height
        dialog%argument%tree => tree

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_cancel_label(dialog, cancel_label)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_no_tags(dialog, no_tags)
        call dialog_set_ok_label(dialog, ok_label)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)

        call dialog_open(dialog, PIPE_RDONLY)
    end subroutine dialog_treeview

    integer function dialog_yesno(text, height, width, ascii_lines, aspect, backtitle, &
            clear, colors, cr_wrap, default_no, extra_button, extra_label, help_button, &
            help_label, hfile, hline, no_collapse, no_label, no_mouse, no_shadow, timeout, &
            title, yes_label) result(answer)
        character(len=*), intent(in)           :: text
        integer,          intent(in)           :: height
        integer,          intent(in)           :: width
        logical,          intent(in), optional :: ascii_lines
        integer,          intent(in), optional :: aspect
        character(len=*), intent(in), optional :: backtitle
        logical,          intent(in), optional :: clear
        logical,          intent(in), optional :: colors
        logical,          intent(in), optional :: cr_wrap
        logical,          intent(in), optional :: default_no
        logical,          intent(in), optional :: extra_button
        character(len=*), intent(in), optional :: extra_label
        logical,          intent(in), optional :: help_button
        character(len=*), intent(in), optional :: help_label
        character(len=*), intent(in), optional :: hfile
        character(len=*), intent(in), optional :: hline
        logical,          intent(in), optional :: no_collapse
        character(len=*), intent(in), optional :: no_label
        logical,          intent(in), optional :: no_mouse
        logical,          intent(in), optional :: no_shadow
        integer,          intent(in), optional :: timeout
        character(len=*), intent(in), optional :: title
        character(len=*), intent(in), optional :: yes_label

        type(dialog_type) :: dialog

        call dialog_create(dialog, WIDGET_YESNO, text, height, width)

        call dialog_set_ascii_lines(dialog, ascii_lines)
        call dialog_set_aspect(dialog, aspect)
        call dialog_set_backtitle(dialog, backtitle)
        call dialog_set_clear(dialog, clear)
        call dialog_set_colors(dialog, colors)
        call dialog_set_cr_wrap(dialog, cr_wrap)
        call dialog_set_default_no(dialog, default_no)
        call dialog_set_extra_button(dialog, extra_button)
        call dialog_set_extra_label(dialog, extra_label)
        call dialog_set_help_button(dialog, help_button)
        call dialog_set_help_label(dialog, help_label)
        call dialog_set_hfile(dialog, hfile)
        call dialog_set_hline(dialog, hline)
        call dialog_set_no_collapse(dialog, no_collapse)
        call dialog_set_no_label(dialog, no_label)
        call dialog_set_no_mouse(dialog, no_mouse)
        call dialog_set_no_shadow(dialog, no_shadow)
        call dialog_set_timeout(dialog, timeout)
        call dialog_set_title(dialog, title)
        call dialog_set_yes_label(dialog, yes_label)

        call dialog_exec(dialog, answer)
    end function dialog_yesno

    ! ******************************************************************
    ! PRIVATE PROCEDURES
    ! ******************************************************************
    subroutine dialog_command(dialog)
        type(dialog_type), intent(inout) :: dialog
        integer                          :: i

        if (dialog%widget == WIDGET_NONE) return

        dialog%cmd = dialog_executable

        ! Common options.
        if (dialog%options(C_ASCII_LINES)) call add_str('--ascii-lines')

        if (dialog%options(C_ASPECT)) then
            call add_str('--aspect')
            call add_int(dialog%common%aspect)
        end if

        if (dialog%options(C_BACKTITLE)) then
            call add_str('--backtitle')
            call add_str(dialog%common%backtitle, .true.)
        end if

        if (dialog%options(C_BEGIN)) then
            call add_str('--begin')
            call add_int(dialog%common%begin_y)
            call add_int(dialog%common%begin_x)
        end if

        if (dialog%options(C_CANCEL_LABEL)) then
            call add_str('--cancel-label')
            call add_str(dialog%common%cancel_label, .true.)
        end if

        if (dialog%options(C_CLEAR)) call add_str('--clear')
        if (dialog%options(C_COLORS)) call add_str('--colors')

        if (dialog%options(C_COLUMN_SEPARATOR)) then
            call add_str('--column-separator')
            call add_str(dialog%common%column_separator, .true.)
        end if

        if (dialog%options(C_CR_WRAP)) call add_str('--cr-wrap')
        if (dialog%options(C_CURSOR_OFF_LABEL)) call add_str('--cursor-off-label')

        if (dialog%options(C_DATE_FORMAT)) then
            call add_str('--date-format')
            call add_str(dialog%common%date_format, .true.)
        end if

        if (dialog%options(C_DEFAULT_BUTTON)) then
            call add_str('--default-button')
            call add_str(dialog%common%default_button, .true.)
        end if

        if (dialog%options(C_DEFAULT_ITEM)) then
            call add_str('--default-item')
            call add_str(dialog%common%default_item, .true.)
        end if

        if (dialog%options(C_DEFAULT_NO)) call add_str('--defaultno')
        if (dialog%options(C_ERASE_ON_EXIT)) call add_str('--erase-on-exit')

        if (dialog%options(C_EXIT_LABEL)) then
            call add_str('--exit-label')
            call add_str(dialog%common%exit_label, .true.)
        end if

        if (dialog%options(C_EXTRA_BUTTON)) call add_str('--extra-button')

        if (dialog%options(C_EXTRA_LABEL)) then
            call add_str('--extra-label')
            call add_str(dialog%common%extra_label, .true.)
        end if

        if (dialog%options(C_HELP_BUTTON)) call add_str('--help-button')

        if (dialog%options(C_HELP_LABEL)) then
            call add_str('--help-label')
            call add_str(dialog%common%help_label, .true.)
        end if

        if (dialog%options(C_HELP_STATUS)) call add_str('--help-status')
        if (dialog%options(C_HELP_TAGS)) call add_str('--help-tags')

        if (dialog%options(C_HFILE)) then
            call add_str('--hfile')
            call add_str(dialog%common%hfile, .true.)
        end if

        if (dialog%options(C_HLINE)) then
            call add_str('--hline')
            call add_str(dialog%common%hline, .true.)
        end if

        if (dialog%options(C_IGNORE)) call add_str('--ignore')

        if (dialog%options(C_INPUT_FD)) then
            call add_str('--input-fd')
            call add_int(dialog%common%input_fd)
        end if

        if (dialog%options(C_INSECURE))    call add_str('--insecure')
        if (dialog%options(C_ISO_WEEK))    call add_str('--iso-week')
        if (dialog%options(C_ITEM_HELP))   call add_str('--item-help')
        if (dialog%options(C_KEEP_TITLE))  call add_str('--keep-title')
        if (dialog%options(C_KEEP_WINDOW)) call add_str('--keep-window')
        if (dialog%options(C_LAST_KEY))    call add_str('--last-key')

        if (dialog%options(C_MAX_INPUT)) then
            call add_str('--max-input')
            call add_int(dialog%common%max_input)
        end if

        if (dialog%options(C_NO_CANCEL))   call add_str('--no-cancel')
        if (dialog%options(C_NO_COLLAPSE)) call add_str('--no-collapse')
        if (dialog%options(C_NO_HOT_LIST)) call add_str('--no-hot-list')
        if (dialog%options(C_NO_ITEMS))    call add_str('--no-items')
        if (dialog%options(C_NO_KILL))     call add_str('--no-kill')

        if (dialog%options(C_NO_LABEL)) then
            call add_str('--no-label')
            call add_str(dialog%common%no_label, .true.)
        end if

        if (dialog%options(C_NO_LINES))     call add_str('--no-lines')
        if (dialog%options(C_NO_MOUSE))     call add_str('--no-mouse')
        if (dialog%options(C_NO_NL_EXPAND)) call add_str('--no-nl-expand')
        if (dialog%options(C_NO_OK))        call add_str('--no-ok')
        if (dialog%options(C_NO_SHADOW))    call add_str('--no-shadow')
        if (dialog%options(C_NO_TAGS))      call add_str('--no-tags')

        if (dialog%options(C_OK_LABEL)) then
            call add_str('--ok-label')
            call add_str(dialog%common%ok_label, .true.)
        end if

        if (dialog%options(C_OUTPUT_FD)) then
            call add_str('--output-fd')
            call add_int(dialog%common%output_fd)
        end if

        if (dialog%options(C_QUOTED))          call add_str('--quoted')
        if (dialog%options(C_REORDER))         call add_str('--reorder')
        if (dialog%options(C_SCROLLBAR))       call add_str('--scrollbar')
        if (dialog%options(C_SEPARATE_OUTPUT)) call add_str('--separate-output')

        if (dialog%options(C_SEPARATE_WIDGET)) then
            call add_str('--separate-widget')
            call add_str(dialog%common%separate_widget, .true.)
        end if

        if (dialog%options(C_SEPARATOR)) then
            call add_str('--separator')
            call add_str(dialog%common%separator, .true.)
        end if

        if (dialog%options(C_SINGLE_QUOTED)) call add_str('--single-quoted')

        if (dialog%options(C_SLEEP)) then
            call add_str('--sleep')
            call add_int(dialog%common%sleep)
        end if

        if (.not. dialog%options(C_STDERR)) call add_str('--stdout')
        if (dialog%options(C_TAB_CORRECT))  call add_str('--tab-correct')

        if (dialog%options(C_TAB_LEN)) then
            call add_str('--tab-len')
            call add_int(dialog%common%tab_len)
        end if

        if (dialog%options(C_TIMEOUT)) then
            call add_str('--timeout')
            call add_int(dialog%common%timeout)
        end if

        if (dialog%options(C_TIME_FORMAT)) then
            call add_str('--time-format')
            call add_str(dialog%common%time_format, .true.)
        end if

        if (dialog%options(C_TITLE)) then
            call add_str('--title')
            call add_str(dialog%common%title, .true.)
        end if

        if (dialog%options(C_TRACE))       call add_str('--trace')
        if (dialog%options(C_TRIM))        call add_str('--trim')
        if (dialog%options(C_VISIT_ITEMS)) call add_str('--visit-items')

        if (dialog%options(C_WEEK_START)) then
            call add_str('--week-start')
            call add_str(dialog%common%week_start, .true.)
        end if

        if (dialog%options(C_YES_LABEL)) then
            call add_str('--yes-label')
            call add_str(dialog%common%yes_label, .true.)
        end if

        ! Widget type.
        call add_str('--' // WIDGET_NAMES(dialog%widget))

        ! Widget arguments.
        select case (dialog%widget)
            case (WIDGET_PRGBOX)
                if (len_trim(dialog%argument%text) > 0) &
                    call add_str(dialog%argument%text, .true.)
                call add_str(dialog%argument%command, .true.)

            case (WIDGET_PROGRAMBOX, WIDGET_PROGRESSBOX)
                if (len_trim(dialog%argument%text) > 0) &
                    call add_str(dialog%argument%text, .true.)

            case default
                call add_str(dialog%argument%text, .true.)
        end select

        call add_int(dialog%argument%height)
        call add_int(dialog%argument%width)

        select case (dialog%widget)
            case (WIDGET_BUILDLIST, WIDGET_CHECKLIST, WIDGET_RADIOLIST)
                call add_int(dialog%argument%list_height)

                do i = 1, size(dialog%argument%list)
                    call add_str(dialog%argument%list(i)%tag, .true.)
                    call add_str(dialog%argument%list(i)%item, .true.)
                    call add_str(dialog%argument%list(i)%status, .false.)
                end do

            case (WIDGET_CALENDAR)
                call add_int(dialog%argument%day)
                call add_int(dialog%argument%month)
                call add_int(dialog%argument%year)

            case (WIDGET_FORM, WIDGET_PASSWORDFORM)
                call add_int(dialog%argument%form_height)

                do i = 1, size(dialog%argument%form)
                    call add_str(dialog%argument%form(i)%label, .true.)
                    call add_int(dialog%argument%form(i)%label_y)
                    call add_int(dialog%argument%form(i)%label_x)
                    call add_str(dialog%argument%form(i)%item, .true.)
                    call add_int(dialog%argument%form(i)%item_y)
                    call add_int(dialog%argument%form(i)%item_x)
                    call add_int(dialog%argument%form(i)%flen)
                    call add_int(dialog%argument%form(i)%ilen)
                end do

            case (WIDGET_GAUGE)
                call add_int(dialog%argument%percent)

            case (WIDGET_INPUTBOX, WIDGET_PASSWORDBOX)
                if (len_trim(dialog%argument%init) > 0) &
                    call add_str(dialog%argument%init, .true.)

            case (WIDGET_INPUTMENU, WIDGET_MENU)
                call add_int(dialog%argument%menu_height)

                do i = 1, size(dialog%argument%menu)
                    call add_str(dialog%argument%menu(i)%tag, .true.)
                    call add_str(dialog%argument%menu(i)%item, .true.)
                end do

            case (WIDGET_MIXEDFORM)
                call add_int(dialog%argument%form_height)

                do i = 1, size(dialog%argument%form)
                    call add_str(dialog%argument%form(i)%label, .true.)
                    call add_int(dialog%argument%form(i)%label_y)
                    call add_int(dialog%argument%form(i)%label_x)
                    call add_str(dialog%argument%form(i)%item, .true.)
                    call add_int(dialog%argument%form(i)%item_y)
                    call add_int(dialog%argument%form(i)%item_x)
                    call add_int(dialog%argument%form(i)%flen)
                    call add_int(dialog%argument%form(i)%ilen)
                    call add_int(dialog%argument%form(i)%itype)
                end do

            case (WIDGET_MIXEDGAUGE)
                call add_int(dialog%argument%percent)

                do i = 1, size(dialog%argument%gauge)
                    call add_str(dialog%argument%gauge(i)%tag, .true.)
                    call add_str(dialog%argument%gauge(i)%item, .true.)
                end do

            case (WIDGET_PAUSE)
                call add_int(dialog%argument%seconds)

            case (WIDGET_RANGEBOX)
                call add_int(dialog%argument%min_value)
                call add_int(dialog%argument%max_value)
                call add_int(dialog%argument%default_value)

            case (WIDGET_TIMEBOX)
                call add_int(dialog%argument%hour)
                call add_int(dialog%argument%minute)
                call add_int(dialog%argument%second)

            case (WIDGET_TREEVIEW)
                call add_int(dialog%argument%tree_height)

                do i = 1, size(dialog%argument%tree)
                    call add_str(dialog%argument%tree(i)%tag, .true.)
                    call add_str(dialog%argument%tree(i)%item, .true.)
                    call add_str(dialog%argument%tree(i)%status, .true.)
                    call add_int(dialog%argument%tree(i)%depth)
                end do
        end select
    contains
        subroutine add_int(arg)
            integer, intent(in) :: arg
            character(len=20)   :: a

            write (a, '(i0)') arg
            call add_str(a)
        end subroutine add_int

        subroutine add_str(arg, quote)
            character(len=*), parameter :: Q1 = " '"
            character(len=*), parameter :: Q2 = "'"

            character(len=*), intent(in)           :: arg
            logical,          intent(in), optional :: quote
            logical                                :: quote_

            quote_ = .false.
            if (present(quote)) quote_ = quote

            if (quote_) then
                dialog%cmd = trim(dialog%cmd) // Q1 // trim(arg) // Q2
            else
                dialog%cmd = trim(dialog%cmd) // ' ' // trim(arg)
            end if
        end subroutine add_str
    end subroutine dialog_command

    subroutine dialog_create(dialog, widget, text, height, width)
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in)           :: widget
        character(len=*),  intent(in), optional :: text
        integer,           intent(in), optional :: height
        integer,           intent(in), optional :: width

        dialog%widget = widget
        if (present(text))   dialog%argument%text   = text
        if (present(height)) dialog%argument%height = height
        if (present(width))  dialog%argument%width  = width
    end subroutine dialog_create

    subroutine dialog_exec(dialog, exit_stat)
        type(dialog_type), intent(inout)         :: dialog
        integer,           intent(out), optional :: exit_stat

        call dialog_command(dialog)

        if (present(exit_stat)) then
            call execute_command_line(trim(dialog%cmd), exitstat=exit_stat)
        else
            call execute_command_line(trim(dialog%cmd))
        end if

        nullify (dialog%argument%form)
        nullify (dialog%argument%gauge)
        nullify (dialog%argument%list)
        nullify (dialog%argument%menu)
        nullify (dialog%argument%tree)
    end subroutine dialog_exec

    subroutine dialog_open(dialog, mode)
        type(dialog_type), intent(inout) :: dialog
        integer,           intent(in)    :: mode

        call dialog_command(dialog)
        if (c_associated(dialog%pipe%ptr)) return

        select case (mode)
            case (PIPE_RDONLY)
                dialog%pipe%ptr = c_popen(trim(dialog%cmd) // c_null_char, 'r' // c_null_char)
            case (PIPE_WRONLY)
                dialog%pipe%ptr = c_popen(trim(dialog%cmd) // c_null_char, 'w' // c_null_char)
            case default
                return
        end select

        dialog%pipe%mode = mode
    end subroutine dialog_open

    ! ******************************************************************
    ! COMMON OPTION ROUTINES
    ! ******************************************************************
    subroutine dialog_set_ascii_lines(dialog, ascii_lines)
        !! --ascii-lines
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: ascii_lines

        if (.not. present(ascii_lines)) return
        dialog%options(C_ASCII_LINES) = ascii_lines
    end subroutine dialog_set_ascii_lines

    subroutine dialog_set_aspect(dialog, aspect)
        !! --aspect <ratio>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: aspect

        if (.not. present(aspect)) return
        dialog%options(C_ASPECT) = .true.
        dialog%common%aspect = aspect
    end subroutine dialog_set_aspect

    subroutine dialog_set_backtitle(dialog, backtitle)
        !! --backtitle <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: backtitle

        if (.not. present(backtitle)) return
        dialog%options(C_BACKTITLE) = .true.
        dialog%common%backtitle = backtitle
    end subroutine dialog_set_backtitle

    subroutine dialog_set_begin(dialog, begin_x, begin_y)
        !! --begin <y> <x>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: begin_x
        integer,           intent(in), optional :: begin_y

        if (.not. present(begin_x) .or. .not. present(begin_y)) return
        dialog%options(C_begin) = .true.
        dialog%common%begin_x = begin_x
        dialog%common%begin_y = begin_y
    end subroutine dialog_set_begin

    subroutine dialog_set_cancel_label(dialog, cancel_label)
        !! --cancel-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: cancel_label

        if (.not. present(cancel_label)) return
        dialog%options(C_CANCEL_LABEL) = .true.
        dialog%common%cancel_label = cancel_label
    end subroutine dialog_set_cancel_label

    subroutine dialog_set_clear(dialog, clear)
        !! --clear
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: clear

        if (.not. present(clear)) return
        dialog%options(C_CLEAR) = clear
    end subroutine dialog_set_clear

    subroutine dialog_set_colors(dialog, colors)
        !! --colors
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: colors

        if (.not. present(colors)) return
        dialog%options(C_COLORS) = colors
    end subroutine dialog_set_colors

    subroutine dialog_set_column_separator(dialog, column_separator)
        !! --column-separator <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: column_separator

        if (.not. present(column_separator)) return
        dialog%options(C_COLUMN_SEPARATOR) = .true.
        dialog%common%column_separator = column_separator
    end subroutine dialog_set_column_separator

    subroutine dialog_set_cr_wrap(dialog, cr_wrap)
        !! --cr-wrap
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: cr_wrap

        if (.not. present(cr_wrap)) return
        dialog%options(C_CR_WRAP) = cr_wrap
    end subroutine dialog_set_cr_wrap

    subroutine dialog_set_cursor_off_label(dialog, cursor_off_label)
        !! --cursor-off-label
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: cursor_off_label

        if (.not. present(cursor_off_label)) return
        dialog%options(C_CURSOR_OFF_LABEL) = cursor_off_label
    end subroutine dialog_set_cursor_off_label

    subroutine dialog_set_date_format(dialog, date_format)
        !! --data-format <format>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: date_format

        if (.not. present(date_format)) return
        dialog%options(C_DATE_FORMAT) = .true.
        dialog%common%date_format = date_format
    end subroutine dialog_set_date_format

    subroutine dialog_set_default_button(dialog, default_button)
        !! --default-button <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: default_button

        if (.not. present(default_button)) return
        dialog%options(C_DEFAULT_BUTTON) = .true.
        dialog%common%default_button = default_button
    end subroutine dialog_set_default_button

    subroutine dialog_set_default_item(dialog, default_item)
        !! --default-item <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: default_item

        if (.not. present(default_item)) return
        dialog%options(C_DEFAULT_ITEM) = .true.
        dialog%common%default_item = default_item
    end subroutine dialog_set_default_item

    subroutine dialog_set_default_no(dialog, default_no)
        !! --defaultno
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: default_no

        if (.not. present(default_no)) return
        dialog%options(C_DEFAULT_NO) = default_no
    end subroutine dialog_set_default_no

    subroutine dialog_set_erase_on_exit(dialog, erase_on_exit)
        !! --erase-on-exit
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: erase_on_exit

        if (.not. present(erase_on_exit)) return
        dialog%options(C_ERASE_ON_EXIT) = erase_on_exit
    end subroutine dialog_set_erase_on_exit

    subroutine dialog_set_exit_label(dialog, exit_label)
        !! --exit-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: exit_label

        if (.not. present(exit_label)) return
        dialog%options(C_EXIT_LABEL) = .true.
        dialog%common%exit_label = exit_label
    end subroutine dialog_set_exit_label

    subroutine dialog_set_extra_button(dialog, extra_button)
        !! --extra-button
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: extra_button

        if (.not. present(extra_button)) return
        dialog%options(C_EXTRA_BUTTON) = extra_button
    end subroutine dialog_set_extra_button

    subroutine dialog_set_extra_label(dialog, extra_label)
        !! --extra-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: extra_label

        if (.not. present(extra_label)) return
        dialog%options(C_EXTRA_LABEL) = .true.
        dialog%common%extra_label = extra_label
    end subroutine dialog_set_extra_label

    subroutine dialog_set_help_button(dialog, help_button)
        !! --help-button
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: help_button

        if (.not. present(help_button)) return
        dialog%options(C_HELP_BUTTON) = help_button
    end subroutine dialog_set_help_button

    subroutine dialog_set_help_label(dialog, help_label)
        !! --help-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: help_label

        if (.not. present(help_label)) return
        dialog%options(C_HELP_LABEL) = .true.
        dialog%common%help_label = help_label
    end subroutine dialog_set_help_label

    subroutine dialog_set_help_status(dialog, help_status)
        !! --help-status
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: help_status

        if (.not. present(help_status)) return
        dialog%options(C_HELP_STATUS) = help_status
    end subroutine dialog_set_help_status

    subroutine dialog_set_help_tags(dialog, help_tags)
        !! --help-tags
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: help_tags

        if (.not. present(help_tags)) return
        dialog%options(C_HELP_TAGS) = help_tags
    end subroutine dialog_set_help_tags

    subroutine dialog_set_hfile(dialog, hfile)
        !! --hfile <file>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: hfile

        if (.not. present(hfile)) return
        dialog%options(C_HFILE) = .true.
        dialog%common%hfile = hfile
    end subroutine dialog_set_hfile

    subroutine dialog_set_hline(dialog, hline)
        !! --hline <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: hline

        if (.not. present(hline)) return
        dialog%options(C_HLINE) = .true.
        dialog%common%hline = hline
    end subroutine dialog_set_hline

    subroutine dialog_set_ignore(dialog, ignore)
        !! --ignore
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: ignore

        if (.not. present(ignore)) return
        dialog%options(C_IGNORE) = ignore
    end subroutine dialog_set_ignore

    subroutine dialog_set_input_fd(dialog, input_fd)
        !! --input-fd <fd>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: input_fd

        if (.not. present(input_fd)) return
        dialog%options(C_INPUT_FD) = .true.
        dialog%common%input_fd = input_fd
    end subroutine dialog_set_input_fd

    subroutine dialog_set_insecure(dialog, insecure)
        !! --insecure
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: insecure

        if (.not. present(insecure)) return
        dialog%options(C_INSECURE) = insecure
    end subroutine dialog_set_insecure

    subroutine dialog_set_iso_week(dialog, iso_week)
        !! --iso-week
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: iso_week

        if (.not. present(iso_week)) return
        dialog%options(C_ISO_WEEK) = iso_week
    end subroutine dialog_set_iso_week

    subroutine dialog_set_item_help(dialog, item_help)
        !! --item-help
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: item_help

        if (.not. present(item_help)) return
        dialog%options(C_ITEM_HELP) = item_help
    end subroutine dialog_set_item_help

    subroutine dialog_set_keep_title(dialog, keep_title)
        !! --keep-title
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: keep_title

        if (.not. present(keep_title)) return
        dialog%options(C_KEEP_TITLE) = keep_title
    end subroutine dialog_set_keep_title

    subroutine dialog_set_keep_window(dialog, keep_window)
        !! --keep-window
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: keep_window

        if (.not. present(keep_window)) return
        dialog%options(C_KEEP_WINDOW) = keep_window
    end subroutine dialog_set_keep_window

    subroutine dialog_set_last_key(dialog, last_key)
        !! --last-key
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: last_key

        if (.not. present(last_key)) return
        dialog%options(C_LAST_KEY) = last_key
    end subroutine dialog_set_last_key

    subroutine dialog_set_max_input(dialog, max_input)
        !! --max-input <size>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: max_input

        if (.not. present(max_input)) return
        dialog%options(C_MAX_INPUT) = .true.
        dialog%common%max_input = max_input
    end subroutine dialog_set_max_input

    subroutine dialog_set_no_cancel(dialog, no_cancel)
        !! --no-cancel
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_cancel

        if (.not. present(no_cancel)) return
        dialog%options(C_NO_CANCEL) = no_cancel
    end subroutine dialog_set_no_cancel

    subroutine dialog_set_no_collapse(dialog, no_collapse)
        !! --no-collapse
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_collapse

        if (.not. present(no_collapse)) return
        dialog%options(C_NO_COLLAPSE) = no_collapse
    end subroutine dialog_set_no_collapse

    subroutine dialog_set_no_hot_list(dialog, no_hot_list)
        !! --no-hot-list
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_hot_list

        if (.not. present(no_hot_list)) return
        dialog%options(C_NO_HOT_LIST) = no_hot_list
    end subroutine dialog_set_no_hot_list

    subroutine dialog_set_no_items(dialog, no_items)
        !! --no-items
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_items

        if (.not. present(no_items)) return
        dialog%options(C_NO_ITEMS) = no_items
    end subroutine dialog_set_no_items

    subroutine dialog_set_no_kill(dialog, no_kill)
        !! --no-kill
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_kill

        if (.not. present(no_kill)) return
        dialog%options(C_NO_KILL) = no_kill
    end subroutine dialog_set_no_kill

    subroutine dialog_set_no_label(dialog, no_label)
        !! --no-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: no_label

        if (.not. present(no_label)) return
        dialog%options(C_NO_LABEL) = .true.
        dialog%common%no_label = no_label
    end subroutine dialog_set_no_label

    subroutine dialog_set_no_lines(dialog, no_lines)
        !! --no-lines
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_lines

        if (.not. present(no_lines)) return
        dialog%options(C_NO_LINES) = no_lines
    end subroutine dialog_set_no_lines

    subroutine dialog_set_no_mouse(dialog, no_mouse)
        !! --no-mouse
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_mouse

        if (.not. present(no_mouse)) return
        dialog%options(C_NO_MOUSE) = no_mouse
    end subroutine dialog_set_no_mouse

    subroutine dialog_set_no_nl_expand(dialog, no_nl_expand)
        !! --no-nl-expand
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_nl_expand

        if (.not. present(no_nl_expand)) return
        dialog%options(C_NO_NL_EXPAND) = no_nl_expand
    end subroutine dialog_set_no_nl_expand

    subroutine dialog_set_no_ok(dialog, no_ok)
        !! --no-ok
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_ok

        if (.not. present(no_ok)) return
        dialog%options(C_NO_OK) = no_ok
    end subroutine dialog_set_no_ok

    subroutine dialog_set_no_shadow(dialog, no_shadow)
        !! --no-shadow
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_shadow

        if (.not. present(no_shadow)) return
        dialog%options(C_NO_SHADOW) = no_shadow
    end subroutine dialog_set_no_shadow

    subroutine dialog_set_no_tags(dialog, no_tags)
        !! --no-tags
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: no_tags

        if (.not. present(no_tags)) return
        dialog%options(C_NO_TAGS) = no_tags
    end subroutine dialog_set_no_tags

    subroutine dialog_set_ok_label(dialog, ok_label)
        !! --ok-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: ok_label

        if (.not. present(ok_label)) return
        dialog%options(C_OK_LABEL) = .true.
        dialog%common%ok_label = ok_label
    end subroutine dialog_set_ok_label

    subroutine dialog_set_output_fd(dialog, output_fd)
        !! --output-fd <fd>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: output_fd

        if (.not. present(output_fd)) return
        dialog%options(C_OUTPUT_FD) = .true.
        dialog%common%output_fd = output_fd
    end subroutine dialog_set_output_fd

    subroutine dialog_set_quoted(dialog, quoted)
        !! --quoted
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: quoted

        if (.not. present(quoted)) return
        dialog%options(C_QUOTED) = quoted
    end subroutine dialog_set_quoted

    subroutine dialog_set_reorder(dialog, reorder)
        !! --reorder
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: reorder

        if (.not. present(reorder)) return
        dialog%options(C_REORDER) = reorder
    end subroutine dialog_set_reorder

    subroutine dialog_set_scrollbar(dialog, scrollbar)
        !! --scrollbar
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: scrollbar

        if (.not. present(scrollbar)) return
        dialog%options(C_SCROLLBAR) = scrollbar
    end subroutine dialog_set_scrollbar

    subroutine dialog_set_separate_output(dialog, separate_output)
        !! --separate-output
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: separate_output

        if (.not. present(separate_output)) return
        dialog%options(C_SEPARATE_OUTPUT) = separate_output
    end subroutine dialog_set_separate_output

    subroutine dialog_set_separate_widget(dialog, separate_widget)
        !! --separate-widget <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: separate_widget

        if (.not. present(separate_widget)) return
        dialog%options(C_SEPARATE_WIDGET) = .true.
        dialog%common%separate_widget = separate_widget
    end subroutine dialog_set_separate_widget

    subroutine dialog_set_separator(dialog, separator)
        !! --separator <string>
        !! --output-separator <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: separator

        if (.not. present(separator)) return
        dialog%options(C_SEPARATOR) = .true.
        dialog%common%separator = separator
    end subroutine dialog_set_separator

    subroutine dialog_set_single_quoted(dialog, single_quoted)
        !! --single-quoted
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: single_quoted

        if (.not. present(single_quoted)) return
        dialog%options(C_SINGLE_QUOTED) = single_quoted
    end subroutine dialog_set_single_quoted

    subroutine dialog_set_sleep(dialog, sleep)
        !! --sleep <secs>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: sleep

        if (.not. present(sleep)) return
        if (sleep < 0) return
        dialog%options(C_SLEEP) = .true.
        dialog%common%sleep = sleep
    end subroutine dialog_set_sleep

    subroutine dialog_set_stderr(dialog, stderr)
        !! --stderr
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: stderr

        if (.not. present(stderr)) return
        dialog%options(C_STDERR) = stderr
    end subroutine dialog_set_stderr

    subroutine dialog_set_tab_correct(dialog, tab_correct)
        !! --tab-correct
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: tab_correct

        if (.not. present(tab_correct)) return
        dialog%options(C_TAB_CORRECT) = tab_correct
    end subroutine dialog_set_tab_correct

    subroutine dialog_set_tab_len(dialog, tab_len)
        !! --tab-len <n>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: tab_len

        if (.not. present(tab_len)) return
        dialog%options(C_tab_len) = .true.
        dialog%common%tab_len = tab_len
    end subroutine dialog_set_tab_len

    subroutine dialog_set_timeout(dialog, timeout)
        !! --timeout <secs>
        type(dialog_type), intent(inout)        :: dialog
        integer,           intent(in), optional :: timeout

        if (.not. present(timeout)) return
        if (timeout < 0) return
        dialog%options(C_TIMEOUT) = .true.
        dialog%common%timeout = timeout
    end subroutine dialog_set_timeout

    subroutine dialog_set_time_format(dialog, time_format)
        !! --time-format <format>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: time_format

        if (.not. present(time_format)) return
        dialog%options(C_TIME_FORMAT) = .true.
        dialog%common%time_format = time_format
    end subroutine dialog_set_time_format

    subroutine dialog_set_title(dialog, title)
        !! --title <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: title

        if (.not. present(title)) return
        dialog%options(C_TITLE) = .true.
        dialog%common%title = title
    end subroutine dialog_set_title

    subroutine dialog_set_trace(dialog, trace)
        !! --trace
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: trace

        if (.not. present(trace)) return
        dialog%options(C_TRIM) = .true.
        dialog%common%trace = trace
    end subroutine dialog_set_trace

    subroutine dialog_set_trim(dialog, trim)
        !! --trim
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: trim

        if (.not. present(trim)) return
        dialog%options(C_TRIM) = trim
    end subroutine dialog_set_trim

    subroutine dialog_set_visit_items(dialog, visit_items)
        !! --visit-items
        type(dialog_type), intent(inout)        :: dialog
        logical,           intent(in), optional :: visit_items

        if (.not. present(visit_items)) return
        dialog%options(C_VISIT_ITEMS) = visit_items
    end subroutine dialog_set_visit_items

    subroutine dialog_set_week_start(dialog, week_start)
        !! --week-start <day>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: week_start

        if (.not. present(week_start)) return
        dialog%options(C_WEEK_START) = .true.
        dialog%common%week_start = week_start
    end subroutine dialog_set_week_start

    subroutine dialog_set_yes_label(dialog, yes_label)
        !! --yes-label <string>
        type(dialog_type), intent(inout)        :: dialog
        character(len=*),  intent(in), optional :: yes_label

        if (.not. present(yes_label)) return
        dialog%options(C_YES_LABEL) = .true.
        dialog%common%yes_label = yes_label
    end subroutine dialog_set_yes_label
end module dialog
