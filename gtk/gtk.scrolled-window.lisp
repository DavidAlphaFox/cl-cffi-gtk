;;; ----------------------------------------------------------------------------
;;; gtk.scrolled-window.lisp
;;; 
;;; This file contains code from a fork of cl-gtk2.
;;; See http://common-lisp.net/project/cl-gtk2/
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.3. See http://www.gtk.org.
;;;
;;; Copyright (C) 2009 - 2011 Kalyanov Dmitry
;;; Copyright (C) 2011 - 2012 Dieter Kaiser
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
;;; GtkScrolledWindow
;;; 
;;; Adds scrollbars to its child widget
;;;     
;;; Synopsis
;;; 
;;;     GtkScrolledWindow
;;;     
;;;     gtk_scrolled_window_new
;;;     gtk_scrolled_window_get_hadjustment
;;;     gtk_scrolled_window_get_vadjustment
;;;     gtk_scrolled_window_get_hscrollbar
;;;     gtk_scrolled_window_get_vscrollbar
;;;     gtk_scrolled_window_set_policy
;;;     gtk_scrolled_window_add_with_viewport
;;;     gtk_scrolled_window_set_placement
;;;     gtk_scrolled_window_unset_placement
;;;     gtk_scrolled_window_set_shadow_type
;;;     gtk_scrolled_window_set_hadjustment
;;;     gtk_scrolled_window_set_vadjustment
;;;     gtk_scrolled_window_get_placement
;;;     gtk_scrolled_window_get_policy
;;;     gtk_scrolled_window_get_shadow_type
;;;     gtk_scrolled_window_get_min_content_width
;;;     gtk_scrolled_window_set_min_content_width
;;;     gtk_scrolled_window_get_min_content_height
;;;     gtk_scrolled_window_set_min_content_height
;;;     gtk_scrolled_window_set_kinetic_scrolling
;;;     gtk_scrolled_window_get_kinetic_scrolling
;;;     gtk_scrolled_window_set_capture_button_press
;;;     gtk_scrolled_window_get_capture_button_press
;;; 
;;; Object Hierarchy
;;; 
;;;   GObject
;;;    +----GInitiallyUnowned
;;;          +----GtkWidget
;;;                +----GtkContainer
;;;                      +----GtkBin
;;;                            +----GtkScrolledWindow
;;; 
;;; Implemented Interfaces
;;; 
;;; GtkScrolledWindow implements AtkImplementorIface and GtkBuildable.
;;; 
;;; Properties
;;; 
;;;   "hadjustment"              GtkAdjustment*       : Read / Write / Construct
;;;   "hscrollbar-policy"        GtkPolicyType        : Read / Write
;;;   "kinetic-scrolling"        gboolean             : Read / Write
;;;   "min-content-height"       gint                 : Read / Write
;;;   "min-content-width"        gint                 : Read / Write
;;;   "shadow-type"              GtkShadowType        : Read / Write
;;;   "vadjustment"              GtkAdjustment*       : Read / Write / Construct
;;;   "vscrollbar-policy"        GtkPolicyType        : Read / Write
;;;   "window-placement"         GtkCornerType        : Read / Write
;;;   "window-placement-set"     gboolean             : Read / Write
;;; 
;;; Style Properties
;;; 
;;;   "scrollbar-spacing"        gint                 : Read
;;;   "scrollbars-within-bevel"  gboolean             : Read
;;; 
;;; Signals
;;; 
;;;   "move-focus-out"                                : Action
;;;   "scroll-child"                                  : Action
;;; 
;;; Description
;;; 
;;; GtkScrolledWindow is a GtkBin subclass: it's a container the accepts a
;;; single child widget. GtkScrolledWindow adds scrollbars to the child widget
;;; and optionally draws a beveled frame around the child widget.
;;; 
;;; The scrolled window can work in two ways. Some widgets have native scrolling
;;; support; these widgets implement the GtkScrollable interface. Widgets with
;;; native scroll support include GtkTreeView, GtkTextView, and GtkLayout.
;;; 
;;; For widgets that lack native scrolling support, the GtkViewport widget acts
;;; as an adaptor class, implementing scrollability for child widgets that lack
;;; their own scrolling capabilities. Use GtkViewport to scroll child widgets
;;; such as GtkGrid, GtkBox, and so on.
;;; 
;;; If a widget has native scrolling abilities, it can be added to the
;;; GtkScrolledWindow with gtk_container_add(). If a widget does not, you must
;;; first add the widget to a GtkViewport, then add the GtkViewport to the
;;; scrolled window. The convenience function
;;; gtk_scrolled_window_add_with_viewport() does exactly this, so you can ignore
;;; the presence of the viewport.
;;; 
;;; The position of the scrollbars is controlled by the scroll adjustments. See
;;; GtkAdjustment for the fields in an adjustment - for GtkScrollbar, used by
;;; GtkScrolledWindow, the "value" field represents the position of the
;;; scrollbar, which must be between the "lower" field and "upper - page_size."
;;; The "page_size" field represents the size of the visible scrollable area.
;;; The "step_increment" and "page_increment" fields are used when the user asks
;;; to step down (using the small stepper arrows) or page down (using for
;;; example the PageDown key).
;;; 
;;; If a GtkScrolledWindow doesn't behave quite as you would like, or doesn't
;;; have exactly the right layout, it's very possible to set up your own
;;; scrolling with GtkScrollbar and for example a GtkGrid.
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "hadjustment" property
;;; 
;;;   "hadjustment"              GtkAdjustment*       : Read / Write / Construct
;;; 
;;; The GtkAdjustment for the horizontal position.
;;;
;;; ----------------------------------------------------------------------------
;;; The "hscrollbar-policy" property
;;; 
;;;   "hscrollbar-policy"        GtkPolicyType         : Read / Write
;;; 
;;; When the horizontal scrollbar is displayed.
;;; 
;;; Default value: GTK_POLICY_AUTOMATIC
;;;
;;; ----------------------------------------------------------------------------
;;; The "kinetic-scrolling" property
;;; 
;;;   "kinetic-scrolling"        gboolean              : Read / Write
;;; 
;;; The kinetic scrolling behavior flags. Kinetic scrolling only applies to
;;; devices with source GDK_SOURCE_TOUCHSCREEN
;;; 
;;; Default value: TRUE
;;; 
;;; Since 3.4
;;;
;;; ----------------------------------------------------------------------------
;;; The "min-content-height" property
;;; 
;;;   "min-content-height"       gint                  : Read / Write
;;; 
;;; The minimum content height of scrolled_window, or -1 if not set.
;;; 
;;; Allowed values: >= G_MAXULONG
;;; 
;;; Default value: -1
;;; 
;;; Since 3.0
;;;
;;; ----------------------------------------------------------------------------
;;; The "min-content-width" property
;;; 
;;;   "min-content-width"        gint                  : Read / Write
;;; 
;;; The minimum content width of scrolled_window, or -1 if not set.
;;; 
;;; Allowed values: >= G_MAXULONG
;;; 
;;; Default value: -1
;;; 
;;; Since 3.0
;;;
;;; ----------------------------------------------------------------------------
;;; The "shadow-type" property
;;; 
;;;   "shadow-type"              GtkShadowType         : Read / Write
;;; 
;;; Style of bevel around the contents.
;;; 
;;; Default value: GTK_SHADOW_NONE
;;;
;;; ----------------------------------------------------------------------------
;;; The "vadjustment" property
;;; 
;;;   "vadjustment"              GtkAdjustment*        : Read / Write / Construct
;;; 
;;; The GtkAdjustment for the vertical position.
;;;
;;; ----------------------------------------------------------------------------
;;; The "vscrollbar-policy" property
;;; 
;;;   "vscrollbar-policy"        GtkPolicyType         : Read / Write
;;; 
;;; When the vertical scrollbar is displayed.
;;; 
;;; Default value: GTK_POLICY_AUTOMATIC
;;;
;;; ----------------------------------------------------------------------------
;;; The "window-placement" property
;;; 
;;;   "window-placement"         GtkCornerType         : Read / Write
;;; 
;;; Where the contents are located with respect to the scrollbars. This property
;;; only takes effect if "window-placement-set" is TRUE.
;;; 
;;; Default value: GTK_CORNER_TOP_LEFT
;;;
;;; ----------------------------------------------------------------------------
;;; The "window-placement-set" property
;;; 
;;;   "window-placement-set"     gboolean              : Read / Write
;;; 
;;; Whether "window-placement" should be used to determine the location of the
;;; contents with respect to the scrollbars. Otherwise, the
;;; "gtk-scrolled-window-placement" setting is used.
;;; 
;;; Default value: FALSE
;;; 
;;; Since 2.10
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; Style Property Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "scrollbar-spacing" style property
;;; 
;;;   "scrollbar-spacing"        gint                  : Read
;;; 
;;; Number of pixels between the scrollbars and the scrolled window.
;;; 
;;; Allowed values: >= 0
;;; 
;;; Default value: 3
;;;
;;; ----------------------------------------------------------------------------
;;; The "scrollbars-within-bevel" style property
;;; 
;;;   "scrollbars-within-bevel"  gboolean              : Read
;;; 
;;; Whether to place scrollbars within the scrolled window's bevel.
;;; 
;;; Default value: FALSE
;;; 
;;; Since 2.12
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; Signal Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "move-focus-out" signal
;;; 
;;; void user_function (GtkScrolledWindow *scrolled_window,
;;;                     GtkDirectionType   direction_type,
;;;                     gpointer           user_data)            : Action
;;; 
;;; The ::move-focus-out signal is a keybinding signal which gets emitted when
;;; focus is moved away from the scrolled window by a keybinding. The
;;; "move-focus" signal is emitted with direction_type on this scrolled windows
;;; toplevel parent in the container hierarchy. The default bindings for this
;;; signal are Tab+Ctrl and Tab+Ctrl+Shift.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; direction_type :
;;;     either GTK_DIR_TAB_FORWARD or GTK_DIR_TAB_BACKWARD
;;; 
;;; user_data :
;;;     user data set when the signal handler was connected.
;;;
;;; ----------------------------------------------------------------------------
;;; The "scroll-child" signal
;;; 
;;; gboolean user_function (GtkScrolledWindow *scrolled_window,
;;;                         GtkScrollType      scroll,
;;;                         gboolean           horizontal,
;;;                         gpointer           user_data)            : Action
;;; 
;;; The ::scroll-child signal is a keybinding signal which gets emitted when a
;;; keybinding that scrolls is pressed. The horizontal or vertical adjustment is
;;; updated which triggers a signal that the scrolled windows child may listen
;;; to and scroll itself.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; scroll :
;;;     a GtkScrollType describing how much to scroll
;;; 
;;; horizontal :
;;;     whether the keybinding scrolls the child horizontally or not
;;; 
;;; user_data :
;;;     user data set when the signal handler was connected.
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkScrolledWindow
;;; 
;;; struct GtkScrolledWindow;
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkScrolledWindow" gtk-scrolled-window
  (:superclass gtk-bin
   :export t
   :interfaces ("AtkImplementorIface"
                "GtkBuildable")
   :type-initializer "gtk_scrolled_window_get_type")
  ((hadjustment
    gtk-scrolled-window-hadjustment
    "hadjustment" "GtkAdjustment" t t)
   (hscrollbar-policy
    gtk-scrolled-window-hscrollbar-policy
    "hscrollbar-policy" "GtkPolicyType" t t)
   (kinetic-scrolling
    gtk-scrolled-window-kinetic-scrolling
    "kinetic-scrolling" "gboolean" t t)
   (min-content-height
    gtk-scrolled-window-min-content-height
    "min-content-height" "gint" t t)
   (min-content-width
    gtk-scrolled-window-min-content-width
    "min-content-width" "gint" t t)
   (shadow-type
    gtk-scrolled-window-shadow-type
    "shadow-type" "GtkShadowType" t t)
   (vadjustment
    gtk-scrolled-window-vadjustment
    "vadjustment" "GtkAdjustment" t t)
   (vscrollbar-policy
    gtk-scrolled-window-vscrollbar-policy
    "vscrollbar-policy" "GtkPolicyType" t t)
   (window-placement
    gtk-scrolled-window-window-placement
    "window-placement" "GtkCornerType" t t)
   (window-placement-set
    gtk-scrolled-window-window-placement-set
    "window-placement-set" "gboolean" t t)))

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_new ()
;;; 
;;; GtkWidget * gtk_scrolled_window_new (GtkAdjustment *hadjustment,
;;;                                      GtkAdjustment *vadjustment);
;;; 
;;; Creates a new scrolled window.
;;; 
;;; The two arguments are the scrolled window's adjustments; these will be
;;; shared with the scrollbars and the child widget to keep the bars in sync
;;; with the child. Usually you want to pass NULL for the adjustments, which
;;; will cause the scrolled window to create them for you.
;;; 
;;; hadjustment :
;;;     horizontal adjustment
;;; 
;;; vadjustment :
;;;     vertical adjustment
;;; 
;;; Returns :
;;;     a new scrolled window
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-new))

(defun gtk-scrolled-window-new (&optional (hadjustment nil) (vadjustment nil))
  (make-instance 'gtk-scrolled-window
                 :hadjustment hadjustment
                 :vadjustment vadjustment))

(export 'gtk-scrolled-window-new)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_hadjustment ()
;;; 
;;; GtkAdjustment * gtk_scrolled_window_get_hadjustment
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Returns the horizontal scrollbar's adjustment, used to connect the
;;; horizontal scrollbar to the child widget's horizontal scroll functionality.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the horizontal GtkAdjustment
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-hadjustment))

(defun gtk-scrolled-window-get-hadjustment (scrolled-window)
  (gtk-scrolled-window-hadjustment scrolled-window))

(export 'gtk-scrolled-window-get-hadjustment)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_vadjustment ()
;;; 
;;; GtkAdjustment * gtk_scrolled_window_get_vadjustment
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Returns the vertical scrollbar's adjustment, used to connect the vertical
;;; scrollbar to the child widget's vertical scroll functionality.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the vertical GtkAdjustment
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-vadjustment))

(defun gtk-scrolled-window-get-vadjustment (scrolled-window)
  (gtk-scrolled-window-vadjustment scrolled-window))

(export 'gtk-scrolled-window-get-vadjustment)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_hscrollbar ()
;;; 
;;; GtkWidget * gtk_scrolled_window_get_hscrollbar
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Returns the horizontal scrollbar of scrolled_window.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the horizontal scrollbar of the scrolled window, or NULL if it does not
;;;     have one
;;; 
;;; Since 2.8
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_scrolled_window_get_hscrollbar"
           gtk-scrolled-window-get-hscrollbar)
    (g-object gtk-widget)
  (scrolled-window (g-object gtk-scrolled-window)))

(export 'gtk-scrolled-window-get-hscrollbar)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_vscrollbar ()
;;; 
;;; GtkWidget * gtk_scrolled_window_get_vscrollbar
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Returns the vertical scrollbar of scrolled_window.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the vertical scrollbar of the scrolled window, or NULL if it does not
;;;     have one
;;; 
;;; Since 2.8
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_scrolled_window_get_vscrollbar"
           gtk-scrolled-window-get-vscrollbar)
    (g-object gtk-widget)
  (scrolled-window (g-object gtk-scrolled-window)))

(export 'gtk-scrolled-window-get-vscrollbar)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_policy ()
;;; 
;;; void gtk_scrolled_window_set_policy (GtkScrolledWindow *scrolled_window,
;;;                                      GtkPolicyType hscrollbar_policy,
;;;                                      GtkPolicyType vscrollbar_policy);
;;; 
;;; Sets the scrollbar policy for the horizontal and vertical scrollbars.
;;; 
;;; The policy determines when the scrollbar should appear; it is a value from
;;; the GtkPolicyType enumeration. If GTK_POLICY_ALWAYS, the scrollbar is always
;;; present; if GTK_POLICY_NEVER, the scrollbar is never present; if
;;; GTK_POLICY_AUTOMATIC, the scrollbar is present only if needed (that is, if
;;; the slider part of the bar would be smaller than the trough - the display is
;;; larger than the page size).
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; hscrollbar_policy :
;;;     policy for horizontal bar
;;; 
;;; vscrollbar_policy :
;;;     policy for vertical bar
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-policy))

(defun gtk-scrolled-window-set-policy (scrolled-window hscrollbar-policy
                                                       vscrollbar-policy)
  (setf (gtk-scrolled-window-hscrollbar-policy scrolled-window)
        hscrollbar-policy
        (gtk-scrolled-window-vscrollbar-policy scrolled-window)
        vscrollbar-policy))

(export 'gtk-scrolled-window-set-policy)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_add_with_viewport ()
;;; 
;;; void gtk_scrolled_window_add_with_viewport
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          GtkWidget *child);
;;; 
;;; Used to add children without native scrolling capabilities. This is simply a
;;; convenience function; it is equivalent to adding the unscrollable child to a
;;; viewport, then adding the viewport to the scrolled window. If a child has
;;; native scrolling, use gtk_container_add() instead of this function.
;;; 
;;; The viewport scrolls the child by moving its GdkWindow, and takes the size
;;; of the child to be the size of its toplevel GdkWindow. This will be very
;;; wrong for most widgets that support native scrolling; for example, if you
;;; add a widget such as GtkTreeView with a viewport, the whole widget will
;;; scroll, including the column headings. Thus, widgets with native scrolling
;;; support should not be used with the GtkViewport proxy.
;;; 
;;; A widget supports scrolling natively if it implements the GtkScrollable
;;; interface.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; child :
;;;     the widget you want to scroll
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_scrolled_window_add_with_viewport"
          gtk-scrolled-window-add-with-viewport) :void
  (scrolled-window (g-object gtk-scrolled-window))
  (child (g-object gtk-widget)))

(export 'gtk-scrolled-window-add-with-viewport)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_placement ()
;;; 
;;; void gtk_scrolled_window_set_placement (GtkScrolledWindow *scrolled_window,
;;;                                         GtkCornerType window_placement);
;;; 
;;; Sets the placement of the contents with respect to the scrollbars for the
;;; scrolled window.
;;; 
;;; The default is GTK_CORNER_TOP_LEFT, meaning the child is in the top left,
;;; with the scrollbars underneath and to the right. Other values in
;;; GtkCornerType are GTK_CORNER_TOP_RIGHT, GTK_CORNER_BOTTOM_LEFT, and
;;; GTK_CORNER_BOTTOM_RIGHT.
;;; 
;;; See also gtk_scrolled_window_get_placement() and
;;; gtk_scrolled_window_unset_placement().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; window_placement :
;;;     position of the child window
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-placement))

(defun gtk-scrolled-window-set-placement (scrolled-window window-placement)
  (setf (gtk-scrolled-window-window-placement-set scrolled-window)
        t
        (gtk-scrolled-window-window-placement scrolled-window)
        window-placement))

(export 'gtk-scrolled-window-set-placement)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_unset_placement ()
;;; 
;;; void gtk_scrolled_window_unset_placement
;;                                         (GtkScrolledWindow *scrolled_window);
;;; 
;;; Unsets the placement of the contents with respect to the scrollbars for the
;;; scrolled window. If no window placement is set for a scrolled window, it
;;; obeys the "gtk-scrolled-window-placement" XSETTING.
;;; 
;;; See also gtk_scrolled_window_set_placement() and
;;; gtk_scrolled_window_get_placement().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Since 2.10
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-unset-placement))

(defun gtk-scrolled-window-unset-placement (scrolled-window)
  (setf (gtk-scrolled-window-window-placement-set scrolled-window) nil))

(export 'gtk-scrolled-window-unset-placement)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_shadow_type ()
;;; 
;;; void gtk_scrolled_window_set_shadow_type
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          GtkShadowType shadow_type);
;;; 
;;; Changes the type of shadow drawn around the contents of scrolled_window.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; shadow_type :
;;;     kind of shadow to draw around scrolled window contents
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-shadow-type))

(defun gtk-scrolled-window-set-shadow-type (scrolled-window shadow-type)
  (setf (gtk-scrolled-window-shadow-type scrolled-window) shadow-type))

(export 'gtk-scrolled-window-set-shadow-type)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_hadjustment ()
;;; 
;;; void gtk_scrolled_window_set_hadjustment
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          GtkAdjustment *hadjustment);
;;; 
;;; Sets the GtkAdjustment for the horizontal scrollbar.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; hadjustment :
;;;     horizontal scroll adjustment
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-hadjustment))

(defun gtk-scrolled-window-set-hadjustment (scrolled-window hadjustment)
  (setf (gtk-scrolled-window-hadjustment scrolled-window) hadjustment))

(export 'gtk-scrolled-window-set-hadjustment)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_vadjustment ()
;;; 
;;; void gtk_scrolled_window_set_vadjustment
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          GtkAdjustment *vadjustment);
;;; 
;;; Sets the GtkAdjustment for the vertical scrollbar.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; vadjustment :
;;;     vertical scroll adjustment
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-vadjustment))

(defun gtk-scrolled-window-set-vadjustment (scrolled-window vadjustment)
  (setf (gtk-scrolled-window-vadjustment scrolled-window) vadjustment))

(export 'gtk-scrolled-window-set-vadjustment)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_placement ()
;;; 
;;; GtkCornerType gtk_scrolled_window_get_placement
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Gets the placement of the contents with respect to the scrollbars for the
;;; scrolled window. See gtk_scrolled_window_set_placement().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the current placement value. See also
;;;     gtk_scrolled_window_set_placement() and
;;;     gtk_scrolled_window_unset_placement().
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-placement))

(defun gtk-scrolled-window-get-placement (scrolled-window)
  (gtk-scrolled-window-window-placement scrolled-window))

(export 'gtk-scrolled-window-get-placement)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_policy ()
;;; 
;;; void gtk_scrolled_window_get_policy (GtkScrolledWindow *scrolled_window,
;;;                                      GtkPolicyType *hscrollbar_policy,
;;;                                      GtkPolicyType *vscrollbar_policy);
;;; 
;;; Retrieves the current policy values for the horizontal and vertical
;;; scrollbars. See gtk_scrolled_window_set_policy().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; hscrollbar_policy :
;;;     location to store the policy for the horizontal scrollbar, or NULL
;;; 
;;; vscrollbar_policy :
;;;     location to store the policy for the vertical scrollbar, or NULL
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-policy))

(defun gtk-scrolled-window-get-policy (scrolled-window)
  (values (gtk-scrolled-window-hscrollbar-policy scrolled-window)
          (gtk-scrolled-window-vscrollbar-policy scrolled-window)))

(export 'gtk-scrolled-window-get-policy)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_shadow_type ()
;;; 
;;; GtkShadowType gtk_scrolled_window_get_shadow_type
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Gets the shadow type of the scrolled window. See
;;; gtk_scrolled_window_set_shadow_type().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the current shadow type
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-shadow-type))

(defun gtk-scrolled-window-get-shadow-type (scrolled-window)
  (gtk-scrolled-window-shadow-type scrolled-window))

(export 'gtk-scrolled-window-get-shadow-type)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_min_content_width ()
;;; 
;;; gint gtk_scrolled_window_get_min_content_width
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Gets the minimum content width of scrolled_window, or -1 if not set.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the minimum content width
;;; 
;;; Since 3.0
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-min-content-width))

(defun gtk-scrolled-window-get-min-content-width (scrolled-window)
  (gtk-scrolled-window-min-content-width scrolled-window))

(export 'gtk-scrolled-window-get-min-content-width)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_min_content_width ()
;;; 
;;; void gtk_scrolled_window_set_min_content_width
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          gint width);
;;; 
;;; Sets the minimum width that scrolled_window should keep visible. Note that
;;; this can and (usually will) be smaller than the minimum size of the content.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; width :
;;;     the minimal content width
;;; 
;;; Since 3.0
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-min-content-width))

(defun gtk-scrolled-window-set-min-content-width (scrolled-window width)
  (setf (gtk-scrolled-window-min-content-width scrolled-window) width))

(export 'gtk-scrolled-window-set-min-content-width)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_min_content_height ()
;;; 
;;; gint gtk_scrolled_window_get_min_content_height
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Gets the minimal content height of scrolled_window, or -1 if not set.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the minimal content height
;;; 
;;; Since 3.0
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-min-content-height))

(defun gtk-scrolled-window-get-min-content-height (scrolled-window)
  (gtk-scrolled-window-min-content-height scrolled-window))

(export 'gtk-scrolled-window-get-min-content-height)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_min_content_height ()
;;; 
;;; void gtk_scrolled_window_set_min_content_height
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          gint height);
;;; 
;;; Sets the minimum height that scrolled_window should keep visible. Note that
;;; this can and (usually will) be smaller than the minimum size of the content.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; height :
;;;     the minimal content height
;;; 
;;; Since 3.0
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-min-content-height))

(defun gtk-scrolled-window-set-min-content-height (scrolled-window height)
  (setf (gtk-scrolled-window-min-content-height scrolled-window) height))

(export 'gtk-scrolled-window-set-min-content-height)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_kinetic_scrolling ()
;;; 
;;; void gtk_scrolled_window_set_kinetic_scrolling
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          gboolean kinetic_scrolling);
;;; 
;;; Turns kinetic scrolling on or off. Kinetic scrolling only applies to devices
;;; with source GDK_SOURCE_TOUCHSCREEN.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; kinetic_scrolling :
;;;     TRUE to enable kinetic scrolling
;;; 
;;; Since 3.4
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-set-kinetic-scrolling))

(defun gtk-scrolled-window-set-kinetic-scrolling (scrolled-window
                                                  kinetic-scrolling)
  (setf (gtk-scrolled-window-kinetic-scrolling scrolled-window)
        kinetic-scrolling))

(export 'gtk-scrolled-window-set-kinetic-scrolling)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_kinetic_scrolling ()
;;; 
;;; gboolean gtk_scrolled_window_get_kinetic_scrolling
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Returns the specified kinetic scrolling behavior.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     the scrolling behavior flags.
;;; 
;;; Since 3.4
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-scrolled-window-get-kinetic-scrolling))

(defun gtk-scrolled-window-get-kinetic-scrolling (scrolled-window)
  (gtk-scrolled-window-kinetic-scrolling scrolled-window))

(export 'gtk-scrolled-window-get-kinetic-scrolling)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_set_capture_button_press ()
;;; 
;;; void gtk_scrolled_window_set_capture_button_press
;;;                                         (GtkScrolledWindow *scrolled_window,
;;;                                          gboolean capture_button_press);
;;; 
;;; Changes the behaviour of scrolled_window wrt. to the initial event that
;;; possibly starts kinetic scrolling. When capture_button_press is set to TRUE,
;;; the event is captured by the scrolled window, and then later replayed if it
;;; is meant to go to the child widget.
;;; 
;;; This should be enabled if any child widgets perform non-reversible actions
;;; on "button-press-event". If they don't, and handle additionally handle
;;; "grab-broken-event", it might be better to set capture_button_press to
;;; FALSE.
;;; 
;;; This setting only has an effect if kinetic scrolling is enabled.
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; capture_button_press :
;;;     TRUE to capture button presses
;;; 
;;; Since 3.4
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_scrolled_window_set_capture_button_press"
           gtk-scrolled-window-set-capture-button-press) :void
  (scrolled-window (g-object gtk-scrolled-window)
  (capture-button-press :boolean)))

(export 'gtk-scrolled-window-set-capture-button-press)

;;; ----------------------------------------------------------------------------
;;; gtk_scrolled_window_get_capture_button_press ()
;;; 
;;; gboolean gtk_scrolled_window_get_capture_button_press
;;;                                        (GtkScrolledWindow *scrolled_window);
;;; 
;;; Return whether button presses are captured during kinetic scrolling. See
;;; gtk_scrolled_window_set_capture_button_press().
;;; 
;;; scrolled_window :
;;;     a GtkScrolledWindow
;;; 
;;; Returns :
;;;     TRUE if button presses are captured during kinetic scrolling
;;; 
;;; Since 3.4
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_scrolled_window_get_capture_button_press"
           gtk-scrolled-window-get-capture-button-press) :boolean
  (scrolled-window (g-object gtk-scrolled-window)))

(export 'gtk-scrolled-window-get-capture-button-press)

;;; --- End of file gtk.scrolled-window.lisp -----------------------------------
