;;; ----------------------------------------------------------------------------
;;; gtk.places-sidebar.lisp
;;;
;;; The documentation of this file is taken from the GTK+ 3 Reference Manual
;;; Version 3.24 and modified to document the Lisp binding to the GTK library.
;;; See <http://www.gtk.org>. The API documentation of the Lisp binding is
;;; available from <http://www.crategus.com/books/cl-cffi-gtk/>.
;;;
;;; Copyright (C) 2019 Dieter Kaiser
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU Lesser General Public License for Lisp
;;; as published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version and with a preamble to
;;; the GNU Lesser General Public License that clarifies the terms for use
;;; with Lisp programs and is referred as the LLGPL.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program and the preamble to the Gnu Lesser
;;; General Public License.  If not, see <http://www.gnu.org/licenses/>
;;; and <http://opensource.franz.com/preamble.html>.
;;; ----------------------------------------------------------------------------
;;;
;;; GtkPlacesSidebar
;;;
;;;     Sidebar that displays frequently-used places in the file system
;;;
;;; Types and Values
;;;
;;;     GtkPlacesSidebar
;;;     GtkPlacesOpenFlags
;;;
;;; Functions
;;;
;;;     gtk_places_sidebar_new
;;;     gtk_places_sidebar_set_open_flags                  Accessor
;;;     gtk_places_sidebar_get_open_flags                  Accessor
;;;     gtk_places_sidebar_set_location                    Accessor
;;;     gtk_places_sidebar_get_location                    Accessor
;;;     gtk_places_sidebar_set_show_recent                 Accessor
;;;     gtk_places_sidebar_get_show_recent                 Accessor
;;;     gtk_places_sidebar_set_show_desktop                Accessor
;;;     gtk_places_sidebar_get_show_desktop                Accessor
;;;     gtk_places_sidebar_add_shortcut
;;;     gtk_places_sidebar_remove_shortcut
;;;     gtk_places_sidebar_list_shortcuts
;;;     gtk_places_sidebar_get_nth_bookmark
;;;     gtk_places_sidebar_get_show_connect_to_server      Accessor
;;;     gtk_places_sidebar_set_show_connect_to_server      Accessor
;;;     gtk_places_sidebar_get_local_only                  Accessor
;;;     gtk_places_sidebar_set_local_only                  Accessor
;;;     gtk_places_sidebar_get_show_enter_location         Accessor
;;;     gtk_places_sidebar_set_show_enter_location         Accessor
;;;     gtk_places_sidebar_get_show_trash                  Accessor
;;;     gtk_places_sidebar_set_show_trash                  Accessor
;;;     gtk_places_sidebar_get_show_other_locations        Accessor
;;;     gtk_places_sidebar_set_show_other_locations        Accessor
;;;     gtk_places_sidebar_set_drop_targets_visible
;;;
;;; Properties
;;;
;;;           gboolean   local-only                         Read / Write
;;;              GFile*  location                           Read / Write
;;; GtkPlacesOpenFlags   open-flags                         Read / Write
;;;           gboolean   populate-all                       Read / Write
;;;           gboolean   show-connect-to-server             Read / Write
;;;           gboolean   show-desktop                       Read / Write
;;;           gboolean   show-enter-location                Read / Write
;;;           gboolean   show-other-locations               Read / Write
;;;           gboolean   show-recent                        Read / Write
;;;           gboolean   show-starred-location              Read / Write
;;;           gboolean   show-trash                         Read / Write
;;;
;;; Signals
;;;
;;;               gint   drag-action-ask                    Run Last
;;;               gint   drag-action-requested              Run Last
;;;               void   drag-perform-drop                  Run First
;;;               void   mount                              Run First
;;;               void   open-location                      Run First
;;;               void   populate-popup                     Run First
;;;               void   show-connect-to-server             Run First
;;;               void   show-enter-location                Run First
;;;               void   show-error-message                 Run First
;;;               void   show-other-locations               Run First
;;;               void   show-other-locations-with-flags    Run First
;;;               void   show-starred-location              Run First
;;;               void   unmount                            Run First
;;;
;;; Object Hierarchy
;;;
;;;     GObject
;;;     ╰── GInitiallyUnowned
;;;         ╰── GtkWidget
;;;             ╰── GtkContainer
;;;                 ╰── GtkBin
;;;                     ╰── GtkScrolledWindow
;;;                         ╰── GtkPlacesSidebar
;;;
;;; Implemented Interfaces
;;;
;;;     GtkPlacesSidebar implements AtkImplementorIface and GtkBuildable.
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; enum GtkPlacesOpenFlags
;;; ----------------------------------------------------------------------------

(define-g-flags "GtkPlacesOpenFlags" gtk-places-open-flags
  (:export t
   :type-initializer "gtk_places_open_flags_get_type")
  (:normal     #.(ash 1 0))
  (:new-tab    #.(ash 1 1))
  (:new-window #.(ash 1 2)))

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-open-flags atdoc:*symbol-name-alias*) "Flags"
      (gethash 'gtk-places-open-flags atdoc:*external-symbols*)
 "@version{2019-4-6}
  @begin{short}
    These flags serve two purposes.
  @end{short}
  First, the application can call the @fun{gtk-places-sidebar-set-open-flags}
  function using these flags as a bitmask. This tells the sidebar that the
  application is able to open folders selected from the sidebar in various ways,
  for example, in new tabs or in new windows in addition to the normal mode.

  Second, when one of these values gets passed back to the application in the
  \"open-location\" signal, it means that the application should open the
  selected location in the normal way, in a new tab, or in a new window. The
  sidebar takes care of determining the desired way to open the location, based
  on the modifier keys that the user is pressing at the time the selection is
  made.

  If the application never calls the @fun{gtk-places-sidebar-set-open-flags}
  function, then the sidebar will only use @code{:normal} in the
  \"open-location\" signal. This is the default mode of operation.
  @begin{pre}
(define-g-flags \"GtkPlacesOpenFlags\" gtk-places-open-flags
  (:export t
   :type-initializer \"gtk_places_open_flags_get_type\")
  (:normal     #.(ash 1 0))
  (:new-tab    #.(ash 1 1))
  (:new-window #.(ash 1 2)))
  @end{pre}
  @begin[code]{table}
    @entry[:normal]{This is the default mode that GtkPlacesSidebar uses if no
      other flags are specified. It indicates that the calling application
      should open the selected location in the normal way, for example, in the
      folder view beside the sidebar.}
    @entry[:new-tab]{When passed to the @fun{gtk-places-sidebar-set-open-flags}
      function, this indicates that the application can open folders selected
      from the sidebar in new tabs. This value will be passed to the
      \"open-location\" signal when the user selects that a location be opened
      in a new tab instead of in the standard fashion.}
    @entry[:new-window]{Similar to @code{:new-tab}, but indicates that the
      application can open folders in new windows.}
  @end{table}")

;;; ----------------------------------------------------------------------------
;;; struct GtkPlacesSidebar
;;; ----------------------------------------------------------------------------

(eval-when (:compile-toplevel :load-toplevel :execute)
  (register-object-type "GtkPlacesSidebar" 'gtk-places-sidebar))

(define-g-object-class "GtkPlacesSidebar" gtk-places-sidebar
  (:superclass gtk-scrolled-window
    :export t
    :interfaces ("AtkImplementorIface"
                 "GtkBuildable")
    :type-initializer "gtk_places_sidebar_get_type")
  ((local-only
    gtk-places-sidebar-local-only
    "local-only" "gboolean" t t)
   (location
    gtk-places-sidebar-location
    "location" "GFile" t t)
   (open-flags
    gtk-places-sidebar-open-flags
    "open-flags" "GtkPlacesOpenFlags" t t)
   #+gtk-3-18
   (populate-all
    gtk-places-sidebar-populate-all
    "populate-all" "gboolean" t t)
   (show-connect-to-server
    gtk-places-sidebar-show-connect-to-server
    "show-connect-to-server" "gboolean" t t)
   (show-desktop
    gtk-places-sidebar-show-desktop
    "show-desktop" "gboolean" t t)
   (show-enter-location
    gtk-places-sidebar-show-enter-location
    "show-enter-location" "gboolean" t t)
   (show-other-locations
    gtk-places-sidebar-show-other-locations
    "show-other-locations" "gboolean" t t)
   (show-recent
    gtk-places-sidebar-show-recent
    "show-recent" "gboolean" t t)
   (show-starred-location
    gtk-places-sidebar-show-starred-location
    "show-starred-location" "gboolean" t t)
   (show-trash
    gtk-places-sidebar-show-trash
    "show-trash" "gboolean" t t)))

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-places-sidebar 'type)
 "@version{2019-4-6}
  @begin{short}
    The @sym{gtk-places-sidebar} is a widget that displays a list of
    frequently-used places in the file system: the user’s home directory, the
    user’s bookmarks, and volumes and drives.
  @end{short}
  This widget is used as a sidebar in the @class{gtk-file-chooser} interface and
  may be used by file managers and similar programs.

  The places sidebar displays drives and volumes, and will automatically mount
  or unmount them when the user selects them.

  Applications can hook to various signals in the places sidebar to customize
  its behavior. For example, they can add extra commands to the context menu of
  the sidebar.

  While bookmarks are completely in control of the user, the places sidebar also
  allows individual applications to provide extra shortcut folders that are
  unique to each application. For example, a Paint program may want to add a
  shortcut for a Clipart folder. You can do this with the
  @fun{gtk-places-sidebar-add-shortcut} function.

  To make use of the places sidebar, an application at least needs to connect to
  the \"open-location\" signal. This is emitted when the user selects in the
  sidebar a location to open. The application should also call the
  @fun{gtk-places-sidebar-set-location} function when it changes the
  currently-viewed location.
  @begin[CSS nodes]{dictionary}
    The @sym{gtk-places-sidebar} class uses a single CSS node with name
    @code{placessidebar} and style class @code{.sidebar}.

    Among the children of the places sidebar, the following style classes can be
    used:
    @begin{itemize}
      @item{@code{.sidebar-new-bookmark-row} for the 'Add new bookmark' row}
      @item{@code{.sidebar-placeholder-row} for a row that is a placeholder}
      @item{@code{.has-open-popup} when a popup is open for a row}
    @end{itemize}
  @end{dictionary}
  @begin[Signal Details]{dictionary}
    @subheading{The \"drag-action-ask\" signal}
      @begin{pre}
 lambda (sidebar actions)    : Run Last
      @end{pre}
      The places sidebar emits this signal when it needs to ask the application
      to pop up a menu to ask the user for which drag action to perform.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[actions]{Possible drag actions that need to be asked for.}
        @entry[Returns]{The final drag action that the sidebar should pass to
          the drag side of the drag-and-drop operation.}
      @end{table}
      Since 3.10

    @subheading{The \"drag-action-requested\" signal}
      @begin{pre}
 lambda (sidebar context dest-file source-file-list)    : Run Last
      @end{pre}
      When the user starts a drag-and-drop operation and the sidebar needs to
      ask the application for which drag action to perform, then the sidebar
      will emit this signal.

      The application can evaluate the context for customary actions, or it can
      check the type of the files indicated by @arg{source-file-list} against
      the possible actions for the destination @arg{dest-file}.

      The drag action to use must be the return value of the signal handler.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[context]{@class{gdk-drag-context} with information about the drag
          operation.}
        @entry[dest-file]{@class{g-file} with the tentative location that is
          being hovered for a drop.}
        @entry[source-file-list]{List of @class{g-file} that are being dragged.}
        @entry[Returns]{The drag action to use, for example,
        @code{GDK_ACTION_COPY} or @code{GDK_ACTION_MOVE}, or 0 if no action is
        allowed here, i. e. drops are not allowed in the specified
        @arg{dest-file}.}
      @end{table}
      Since 3.10

    @subheading{The \"drag-perform-drop\" signal}
      @begin{pre}
 lambda (sidebar dest-file source-file-list action)    : Run First
      @end{pre}
      The places sidebar emits this signal when the user completes a
      drag-and-drop operation and one of the sidebar's items is the destination.
      This item is in the @arg{dest-file}, and the @arg{source-file-list} has
      the list of files that are dropped into it and which should be
      copied/moved/etc. based on the specified @arg{action}.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[dest-file]{Destination @class{g-file}.}
        @entry[source-file-list]{List of @class{g-file} that got dropped.}
        @entry[action]{Drop action to perform.}
      @end{table}
      Since 3.10

    @subheading{The \"mount\" signal}
      @begin{pre}
 lambda (sidebar mount-operation)    : Run First
      @end{pre}
      The places sidebar emits this signal when it starts a new operation
      because the user clicked on some location that needs mounting. In this way
      the application using the @sym{gtk-places-sidebar} can track the progress
      of the operation and, for example, show a notification.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[mount-operation]{The @class{g-mount-operation} that is going to
          start.}
      @end{table}
      Since 3.20

    @subheading{The \"open-location\" signal}
      @begin{pre}
 lambda (sidebar location open-flags)    : Run First
      @end{pre}
      The places sidebar emits this signal when the user selects a location in
      it. The calling application should display the contents of that location;
      for example, a file manager should show a list of files in the specified
      location.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[location]{GFile to which the caller should switch.}
        @entry[open-flags]{A single value from the
          @symbol{gtk-places-open-flags} flags specifying how the location
          should be opened.}
      @end{table}
      Since 3.10

    @subheading{The \"populate-popup\" signal}
      @begin{pre}
 lambda (sidebar container selected-item selected-volume)    : Run First
      @end{pre}
      The places sidebar emits this signal when the user invokes a contextual
      popup on one of its items. In the signal handler, the application may add
      extra items to the menu as appropriate. For example, a file manager may
      want to add a \"Properties\" command to the menu.

      It is not necessary to store the @arg{selected-item} for each menu item;
      during their callbacks, the application can use the
      @fun{gtk-places-sidebar-location} slot access function to get the file to
      which the item refers.

      The @arg{selected-item} argument may be @code{nil} in case the selection
      refers to a volume. In this case, @arg{selected-volume} will be
      non-@code{nil}. In this case, the calling application will have to the
      @fun{g-object-ref} function the @arg{selected-volume} and keep it around
      to use it in the callback.

      The container and all its contents are destroyed after the user dismisses
      the popup. The popup is re-created, and thus, this signal is emitted,
      every time the user activates the contextual menu.

      Before 3.18, the container always was a @class{gtk-menu}, and you were
      expected to add your items as @class{gtk-menu-item} objects. Since 3.18,
      the popup may be implemented as a @class{gtk-popover}, in which case
      container will be something else, e. g. a @class{gtk-box}, to which you
      may add @class{gtk-model-button} widgets or other widgets, such as
      @class{gtk-entry}, @class{gtk-spin-button} widgets, etc. If your
      application can deal with this situation, you can set @code{populate-all}
      to @em{true} to request that this signal is emitted for populating
      popovers as well.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[container]{A @class{gtk-menu} or another @class{gtk-container}.}
        @entry[selected-item]{@class{g-file} with the item to which the popup
          should refer, or @code{nil} in the case of a @arg{selected-volume}.}
        @entry[selected-volume]{@class{g-volume} if the selected item is a
          volume, or @code{nil} if it is a file.}
      @end{table}
      Since 3.10

    @subheading{The \"show-connect-to-server\" signal}
      @begin{pre}
 lambda (sidebar)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present an way to connect directly to a network server. For example,
      the application may bring up a dialog box asking for a URL like
      \"sftp://ftp.example.com\". It is up to the application to create the
      corresponding mount by using, for example,
      @code{g_file_mount_enclosing_volume()}.

      @b{Warning:} \"show-connect-to-server\" has been deprecated since version
      3.18 and should not be used in newly-written code. Use the
      \"show-other-locations\" signal to connect to network servers.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
      @end{table}
    @subheading{The \"show-enter-location\" signal}
      @begin{pre}
 lambda (sidebar)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present an way to directly enter a location. For example, the
      application may bring up a dialog box asking for a URL like
      \"http://http.example.com\".
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
      @end{table}
      Since 3.14

    @subheading{The \"show-error-message\" signal}
      @begin{pre}
 lambda (sidebar primary secondary)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present an error message. Most of these messages refer to mounting or
      unmounting media, for example, when a drive cannot be started for some
      reason.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[primary]{Primary message with a summary of the error to show.}
        @entry[secondary]{Secondary message with details of the error to show.}
      @end{table}
      Since 3.10

    @subheading{The \"show-other-locations\" signal}
      @begin{pre}
 lambda (sidebar)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present a way to show other locations e. g. drives and network access
      points. For example, the application may bring up a page showing
      persistent volumes and discovered network addresses.

      @b{Warning:} \"show-other-locations\" has been deprecated since version
      3.20 and should not be used in newly-written code. Use the
      \"show-other-locations-with-flags\" which includes the open flags in order
      to allow the user to specify to open in a new tab or window, in a similar
      way than \"open-location\".
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
      @end{table}
      Since 3.18

    @subheading{The \"show-other-locations-with-flags\" signal}
      @begin{pre}
 lambda (sidebar open-flags)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present a way to show other locations e. g. drives and network access
      points. For example, the application may bring up a page showing
      persistent volumes and discovered network addresses.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[open-flags]{A single value from @symbol{gtk-places-open-flags}
          specifying how it should be opened.}
      @end{table}
      Since 3.20

    @subheading{The \"show-starred-location\" signal}
      @begin{pre}
 lambda (sidebar open-flags)    : Run First
      @end{pre}
      The places sidebar emits this signal when it needs the calling application
      to present a way to show the starred files. In GNOME, starred files are
      implemented by setting the @code{nao:predefined-tag-favorite} tag in the
      tracker database.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[open-flags]{A single value from @symbol{gtk-places-open-flags}
          specifying how the starred file should be opened.}
      @end{table}
      Since 3.22

    @subheading{The \"unmount\" signal}
      @begin{pre}
 lambda (sidebar mount-operation)    : Run First
      @end{pre}
      The places sidebar emits this signal when it starts a new operation
      because the user for example ejected some drive or unmounted a mount. In
      this way the application using the @sym{gtk-places-sidebar} can track the
      progress of the operation and, for example, show a notification.
      @begin[code]{table}
        @entry[sidebar]{The object which received the signal.}
        @entry[mount-operation]{The @code{GMountOperation} that is going to
          start.}
      @end{table}
      Since 3.20
  @end{dictionary}
  @see-class{gtk-file-chooser}")

;;; ----------------------------------------------------------------------------
;;; Property and Accessor Details
;;; ----------------------------------------------------------------------------

;;; --- gtk-places-sidebar-local-only ------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "local-only" 'gtk-places-sidebar)
                     't)
 "The @code{local-only} property of type @code{:boolean} (Read / Write) @br{}
  Whether the sidebar only includes local files. @br{}
  Default value: @code{nil}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-local-only atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-local-only 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{local-only} of the
    @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-location --------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "location" 'gtk-places-sidebar)
                     't)
 "The @code{location} property of type @code{GFile} (Read / Write) @br{}
  The location to highlight in the sidebar.")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-location atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-location 'function)
 "@version{2019-4-8}
  @syntax[]{(gtk-places-sidebar-location object) => location)}
  @syntax[]{(setf (gtk-places-sidebar-location object) location)}
  @argument[object]{a @class{gtk-places-sidebar} widget}
  @argument[location]{location to select, or @code{nil} for no current path}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{location} of the
    @class{gtk-places-sidebar} class.
  @end{short}

  The slot access function @sym{gtk-places-sidebar-open-flags}
  gets the currently selected location in the sidebar. This can be @code{nil}
  when nothing is selected, for example, when @sym{gtk-places-sidebar-location}
  has been called with a location that is not among the sidebar’s list of places
  to show.

  You can use this function to get the selection in the sidebar. Also, if you
  connect to the \"populate-popup\" signal, you can use this function to get the
  location that is being referred to during the callbacks for your menu items.

  The slot access function @sym{(setf gtk-places-sidebar-open-flags)}
  sets the location that is being shown in the widgets surrounding the sidebar,
  for example, in a folder view in a file manager. In turn, the sidebar will
  highlight that location if it is being shown in the list of places, or it will
  unhighlight everything if the location is not among the places in the list.

  Since 3.10
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-open-flags ------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "open-flags" 'gtk-places-sidebar)
                     't)
 "The @code{open-flags} property of type @symbol{gtk-places-open-flags}
  (Read / Write) @br{}
  Modes in which the calling application can open locations selected in the
  sidebar. @br{}
  Default value: @code{:normal}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-open-flags atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-open-flags 'function)
 "@version{2019-4-8}
  @syntax[]{(gtk-places-sidebar-open-flags object) => flags)}
  @syntax[]{(setf (gtk-places-sidebar-open-flags object) flags)}
  @argument[object]{a @class{gtk-places-sidebar} widget}
  @argument[flags]{bitmask of modes in which the calling application can open
    locations}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{open-flags} of the
    @class{gtk-places-sidebar} class.
  @end{short}

  The slot access function @sym{gtk-places-sidebar-open-flags}
  gets the open flags.

  The slot access function @sym{(setf gtk-places-sidebar-open-flags)}
  sets the way in which the calling application can open new locations from the
  places sidebar. For example, some applications only open locations
  \"directly\" into their main view, while others may support opening locations
  in a new notebook tab or a new window.

  This function is used to tell the places sidebar about the ways in which the
  application can open new locations, so that the sidebar can display (or not)
  the \"Open in new tab\" and \"Open in new window\" menu items as appropriate.

  When the \"open-location\" signal is emitted, its flags argument will be set
  to one of the flags that was passed in the @sym{gtk-places-sidebar-open-flags}
  function.

  Passing 0 for flags will cause @code{:normal} to always be sent to callbacks
  for the \"open-location\" signal.

  Since 3.10
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-populate-all ----------------------------------------

#+(and gtk-3-18 cl-cffi-gtk-documentation)
(setf (documentation (atdoc:get-slot-from-name "populate-all"
                      'gtk-places-sidebar) 't)
 "The @code{populate-all} property of type @code{:boolean} (Read / Write) @br{}
  If @code{populate-all} is @em{true}, the \"populate-popup\" signal is also
  emitted for popovers. @br{}
  Default value: @code{nil} @br{}
  Since 3.18")

#+(and gtk-3-18 cl-cffi-gtk-documentation)
(setf (gethash 'gtk-places-sidebar-populate-all atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-populate-all 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{populate-all} of the
    @class{gtk-places-sidebar} class.
  @end{short}

  Since 3.18
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-connect-to-server ------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-connect-to-server"
                      'gtk-places-sidebar) 't)
 "The @code{show-connect-to-server} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes a builtin shortcut to a 'Connect to server'
  dialog. @br{}
  Default value: @code{nil}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-connect-to-server
               atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-connect-to-server 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-connect-to-server} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-desktop ----------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-desktop"
                      'gtk-places-sidebar) 't)
 "The @code{show-desktop} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes a builtin shortcut to the Desktop folder. @br{}
  Default value: @em{true}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-desktop
               atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-desktop 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-desktop} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-enter-location ---------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-enter-location"
                      'gtk-places-sidebar) 't)
 "The @code{show-enter-location} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes a builtin shortcut to manually enter a location.
  @br{}
  Default value: @code{nil}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-enter-location
               atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-enter-location 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-enter-location} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-other-locations --------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-other-locations"
                      'gtk-places-sidebar) 't)
 "The @code{show-other-locations} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes an item to show external locations. @br{}
  Default value: @code{nil}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-other-locations
               atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-other-locations 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-other-locations} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-recent -----------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-recent"
                      'gtk-places-sidebar) 't)
 "The @code{show-recent} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes a builtin shortcut for recent files. @br{}
  Default value: @em{true}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-recent atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-recent 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-recent} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-starred-location -------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-starred-location"
                      'gtk-places-sidebar) 't)
 "The @code{show-starred-location} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes an item to show starred files. @br{}
  Default value: @code{nil}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-starred-location
               atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-starred-location 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-starred-location} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; --- gtk-places-sidebar-show-trash ------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-trash"
                      'gtk-places-sidebar) 't)
 "The @code{show-trash} property of type @code{:boolean}
  (Read / Write) @br{}
  Whether the sidebar includes a builtin shortcut to the Trash location. @br{}
  Default value: @em{true}")

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-places-sidebar-show-trash atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-places-sidebar-show-trash 'function)
 "@version{2019-4-8}
  @begin{short}
    Accessor of the slot @slot[gtk-places-sidebar]{show-trash} of
    the @class{gtk-places-sidebar} class.
  @end{short}
  @see-class{gtk-places-sidebar}")

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_new ()
;;;
;;; GtkWidget * gtk_places_sidebar_new (void);
;;;
;;; Creates a new GtkPlacesSidebar widget.
;;;
;;; The application should connect to at least the “open-location” signal to be
;;; notified when the user makes a selection in the sidebar.
;;;
;;; Returns :
;;;     a newly created GtkPlacesSidebar
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_recent ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_recent (GtkPlacesSidebar *sidebar,
;;;                                     gboolean show_recent);
;;;
;;; Sets whether the sidebar should show an item for recent files. The default
;;; value for this option is determined by the desktop environment, but this
;;; function can be used to override it on a per-application basis.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_recent :
;;;     whether to show an item for recent files
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_recent ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_recent (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with gtk_places_sidebar_set_show_recent()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display a builtin shortcut for recent files
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_desktop ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_desktop (GtkPlacesSidebar *sidebar,
;;;                                     gboolean show_desktop);
;;;
;;; Sets whether the sidebar should show an item for the Desktop folder. The
;;; default value for this option is determined by the desktop environment and
;;; the user’s configuration, but this function can be used to override it on a
;;; per-application basis.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_desktop :
;;;     whether to show an item for the Desktop folder
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_desktop ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_desktop (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with gtk_places_sidebar_set_show_desktop()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display a builtin shortcut to the desktop
;;;     folder.
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_add_shortcut ()
;;;
;;; void
;;; gtk_places_sidebar_add_shortcut (GtkPlacesSidebar *sidebar,
;;;                                  GFile *location);
;;;
;;; Applications may want to present some folders in the places sidebar if they
;;; could be immediately useful to users. For example, a drawing program could
;;; add a “/usr/share/clipart” location when the sidebar is being used in an
;;; “Insert Clipart” dialog box.
;;;
;;; This function adds the specified location to a special place for immutable
;;; shortcuts. The shortcuts are application-specific; they are not shared
;;; across applications, and they are not persistent. If this function is called
;;; multiple times with different locations, then they are added to the
;;; sidebar’s list in the same order as the function is called.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; location :
;;;     location to add as an application-specific shortcut
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_remove_shortcut ()
;;;
;;; void
;;; gtk_places_sidebar_remove_shortcut (GtkPlacesSidebar *sidebar,
;;;                                     GFile *location);
;;;
;;; Removes an application-specific shortcut that has been previously been
;;; inserted with gtk_places_sidebar_add_shortcut(). If the location is not a
;;; shortcut in the sidebar, then nothing is done.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; location :
;;;     location to remove
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_list_shortcuts ()
;;;
;;; GSList *
;;; gtk_places_sidebar_list_shortcuts (GtkPlacesSidebar *sidebar);
;;;
;;; Gets the list of shortcuts.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     A GSList of GFile of the locations that have been added as
;;;     application-specific shortcuts with gtk_places_sidebar_add_shortcut().
;;;     To free this list, you can use
;;;     g_slist_free_full (list, (GDestroyNotify) g_object_unref);
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_nth_bookmark ()
;;;
;;; GFile *
;;; gtk_places_sidebar_get_nth_bookmark (GtkPlacesSidebar *sidebar,
;;;                                      gint n);
;;;
;;; This function queries the bookmarks added by the user to the places sidebar,
;;; and returns one of them. This function is used by GtkFileChooser to
;;; implement the “Alt-1”, “Alt-2”, etc. shortcuts, which activate the
;;; cooresponding bookmark.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; n :
;;;     index of the bookmark to query
;;;
;;; Returns :
;;;     The bookmark specified by the index n , or NULL if no such index exist.
;;;     Note that the indices start at 0, even though the file chooser starts
;;;     them with the keyboard shortcut "Alt-1".
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_connect_to_server ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_connect_to_server
;;;                                (GtkPlacesSidebar *sidebar);
;;;
;;; gtk_places_sidebar_get_show_connect_to_server has been deprecated since
;;; version 3.18 and should not be used in newly-written code.
;;;
;;; It is recommended to group this functionality with the drives and network
;;; location under the new 'Other Location' item
;;;
;;; Returns the value previously set with
;;; gtk_places_sidebar_set_show_connect_to_server()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display a “Connect to Server” item.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_connect_to_server ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_connect_to_server
;;;                                (GtkPlacesSidebar *sidebar,
;;;                                 gboolean show_connect_to_server);
;;;
;;; gtk_places_sidebar_set_show_connect_to_server has been deprecated since
;;; version 3.18 and should not be used in newly-written code.
;;;
;;; It is recommended to group this functionality with the drives and network
;;; location under the new 'Other Location' item
;;;
;;; Sets whether the sidebar should show an item for connecting to a network
;;; server; this is off by default. An application may want to turn this on if
;;; it implements a way for the user to connect to network servers directly.
;;;
;;; If you enable this, you should connect to the “show-connect-to-server”
;;; signal.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_connect_to_server :
;;;     whether to show an item for the Connect to Server command
;;;
;;; Since 3.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_local_only ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_local_only (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with gtk_places_sidebar_set_local_only().
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will only show local files.
;;;
;;; Since 3.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_local_only ()
;;;
;;; void
;;; gtk_places_sidebar_set_local_only (GtkPlacesSidebar *sidebar,
;;;                                    gboolean local_only);
;;;
;;; Sets whether the sidebar should only show local files.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; local_only :
;;;     whether to show only local files
;;;
;;; Since 3.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_enter_location ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_enter_location
;;;                                (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with
;;; gtk_places_sidebar_set_show_enter_location()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display an “Enter Location” item.
;;;
;;; Since 3.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_enter_location ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_enter_location
;;;                                (GtkPlacesSidebar *sidebar,
;;;                                 gboolean show_enter_location);
;;;
;;; Sets whether the sidebar should show an item for entering a location; this
;;; is off by default. An application may want to turn this on if manually
;;; entering URLs is an expected user action.
;;;
;;; If you enable this, you should connect to the “show-enter-location” signal.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_enter_location :
;;;     whether to show an item to enter a location
;;;
;;; Since 3.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_trash ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_trash (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with gtk_places_sidebar_set_show_trash()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display a “Trash” item.
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_trash ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_trash (GtkPlacesSidebar *sidebar,
;;;                                    gboolean show_trash);
;;;
;;; Sets whether the sidebar should show an item for the Trash location.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_trash :
;;;     whether to show an item for the Trash location
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_get_show_other_locations ()
;;;
;;; gboolean
;;; gtk_places_sidebar_get_show_other_locations (GtkPlacesSidebar *sidebar);
;;;
;;; Returns the value previously set with
;;; gtk_places_sidebar_set_show_other_locations()
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; Returns :
;;;     TRUE if the sidebar will display an “Other Locations” item.
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_show_other_locations ()
;;;
;;; void
;;; gtk_places_sidebar_set_show_other_locations
;;;                                (GtkPlacesSidebar *sidebar,
;;;                                 gboolean show_other_locations);
;;;
;;; Sets whether the sidebar should show an item for the application to show an
;;; Other Locations view; this is off by default. When set to TRUE, persistent
;;; devices such as hard drives are hidden, otherwise they are shown in the
;;; sidebar. An application may want to turn this on if it implements a way for
;;; the user to see and interact with drives and network servers directly.
;;;
;;; If you enable this, you should connect to the “show-other-locations” signal.
;;;
;;; sidebar :
;;;     a places sidebar
;;;
;;; show_other_locations :
;;;     whether to show an item for the Other Locations view
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_places_sidebar_set_drop_targets_visible ()
;;;
;;; void
;;; gtk_places_sidebar_set_drop_targets_visible
;;;                                (GtkPlacesSidebar *sidebar,
;;;                                 gboolean visible,
;;;                                 GdkDragContext *context);
;;;
;;; Make the GtkPlacesSidebar show drop targets, so it can show the available
;;; drop targets and a "new bookmark" row. This improves the Drag-and-Drop
;;; experience of the user and allows applications to show all available drop
;;; targets at once.
;;;
;;; This needs to be called when the application is aware of an ongoing drag
;;; that might target the sidebar. The drop-targets-visible state will be unset
;;; automatically if the drag finishes in the GtkPlacesSidebar. You only need
;;; to unset the state when the drag ends on some other widget on your
;;; application.
;;;
;;; sidebar :
;;;     a places sidebar.
;;;
;;; visible :
;;;     whether to show the valid targets or not.
;;;
;;; context :
;;;     drag context used to ask the source about the action that wants to
;;;     perform, so hints are more accurate.
;;;
;;; Since 3.18
;;; ----------------------------------------------------------------------------

;;; --- End of file gtk.places-sidebar.lisp ------------------------------------
