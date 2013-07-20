;;; ----------------------------------------------------------------------------
;;; gtk.spin-button.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See <http://common-lisp.net/project/cl-gtk2/>.
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.6.4. See <http://www.gtk.org>. The API documentation of the
;;; Lisp binding is available at <http://www.crategus.com/books/cl-cffi-gtk/>.
;;;
;;; Copyright (C) 2009 - 2011 Kalyanov Dmitry
;;; Copyright (C) 2011 - 2013 Dieter Kaiser
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
;;; GtkSpinButton
;;;
;;; Retrieve an integer or floating-point number from the user
;;;
;;; Synopsis
;;;
;;;     GtkSpinButton
;;;     GtkSpinButtonUpdatePolicy
;;;     GtkSpinType
;;;
;;;     gtk_spin_button_configure
;;;     gtk_spin_button_new
;;;     gtk_spin_button_new_with_range
;;;     gtk_spin_button_set_adjustment
;;;     gtk_spin_button_get_adjustment
;;;     gtk_spin_button_set_digits
;;;     gtk_spin_button_set_increments
;;;     gtk_spin_button_set_range
;;;     gtk_spin_button_get_value_as_int
;;;     gtk_spin_button_set_value
;;;     gtk_spin_button_set_update_policy
;;;     gtk_spin_button_set_numeric
;;;     gtk_spin_button_spin
;;;     gtk_spin_button_set_wrap
;;;     gtk_spin_button_set_snap_to_ticks
;;;     gtk_spin_button_update
;;;     gtk_spin_button_get_digits
;;;     gtk_spin_button_get_increments
;;;     gtk_spin_button_get_numeric
;;;     gtk_spin_button_get_range
;;;     gtk_spin_button_get_snap_to_ticks
;;;     gtk_spin_button_get_update_policy
;;;     gtk_spin_button_get_value
;;;     gtk_spin_button_get_wrap
;;;     GTK_INPUT_ERROR
;;;
;;; Object Hierarchy
;;;
;;;   GObject
;;;    +----GInitiallyUnowned
;;;          +----GtkWidget
;;;                +----GtkEntry
;;;                      +----GtkSpinButton
;;;
;;; Implemented Interfaces
;;;
;;; GtkSpinButton implements AtkImplementorIface, GtkBuildable, GtkEditable,
;;; GtkCellEditable, and GtkOrientable.
;;;
;;; Style Properties
;;;
;;;   "shadow-type"           GtkShadowType              : Read
;;;
;;; Signals
;;;
;;;   "change-value"                                     : Action
;;;   "input"                                            : Run Last
;;;   "output"                                           : Run Last
;;;   "value-changed"                                    : Run Last
;;;   "wrapped"                                          : Run Last
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkSpinButton
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkSpinButton" gtk-spin-button
  (:superclass gtk-entry
   :export t
   :interfaces ("AtkImplementorIface"
                "GtkBuildable"
                "GtkEditable"
                "GtkCellEditable"
                "GtkOrientable")
   :type-initializer "gtk_spin_button_get_type")
  ((adjustment
    gtk-spin-button-adjustment
    "adjustment" "GtkAdjustment" t t)
   (climb-rate
    gtk-spin-button-climb-rate
    "climb-rate" "gdouble" t t)
   (digits
    gtk-spin-button-digits
    "digits" "guint" t t)
   (numeric
    gtk-spin-button-numeric
    "numeric" "gboolean" t t)
   (snap-to-ticks
    gtk-spin-button-snap-to-ticks
    "snap-to-ticks" "gboolean" t t)
   (update-policy
    gtk-spin-button-update-policy
    "update-policy" "GtkSpinButtonUpdatePolicy" t t)
   (value
    gtk-spin-button-value
    "value" "gdouble" t t)
   (wrap
    gtk-spin-button-wrap
    "wrap" "gboolean" t t)))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-spin-button 'type)
 "@version{2014-4-28}
  @begin{short}
    A @sym{gtk-spin-button} is an ideal way to allow the user to set the value
    of some attribute. Rather than having to directly type a number into a
    @class{gtk-entry}, @sym{gtk-spin-button} allows the user to click on one of
    two arrows to increment or decrement the displayed value. A value can still
    be typed in, with the bonus that it can be checked to ensure it is in a
    given range.
  @end{short}

  The main properties of a @sym{gtk-spin-button} are through an adjustment. See
  the @class{gtk-adjustment} section for more details about an adjustment's
  properties.

  @b{Example:} Using a @class{gtk-spin-button} to get an integer
  @begin{pre}
 /* Provides a function to retrieve an integer value from a
  * GtkSpinButton and creates a spin button to model percentage
  * values.
  */

 gint
 grab_int_value (GtkSpinButton *button,
                 gpointer       user_data)
 {
   return gtk_spin_button_get_value_as_int (button);
 @}

 void
 create_integer_spin_button (void)
 {

   GtkWidget *window, *button;
   GtkAdjustment *adjustment;

   adjustment = gtk_adjustment_new (50.0, 0.0, 100.0, 1.0, 5.0, 0.0);

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_container_set_border_width (GTK_CONTAINER (window), 5);

   /* creates the spinbutton, with no decimal places */
   button = gtk_spin_button_new (adjustment, 1.0, 0);
    gtk_container_add (GTK_CONTAINER (window), button);

   gtk_widget_show_all (window);
 @}
  @end{pre}
  @b{Example:} Using a @sym{gtk-spin-button} to get a floating point value
  @begin{pre}
 /* Provides a function to retrieve a floating point value from a
  * GtkSpinButton, and creates a high precision spin button.
  */

 gfloat
 grab_float_value (GtkSpinButton *button,
                   gpointer       user_data)
 {
   return gtk_spin_button_get_value (button);
 @}

 void
 create_floating_spin_button (void)
 {
   GtkWidget *window, *button;
   GtkAdjustment *adjustment;

   adjustment = gtk_adjustment_new (2.500, 0.0, 5.0, 0.001, 0.1, 0.0);

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_container_set_border_width (GTK_CONTAINER (window), 5);

   /* creates the spinbutton, with three decimal places */
   button = gtk_spin_button_new (adjustment, 0.001, 3);
   gtk_container_add (GTK_CONTAINER (window), button);

   gtk_widget_show_all (window);
 @}
  @end{pre}
  @begin[Style Property Details]{dictionary}
    @subheading{The \"shadow-type\" style property}
      @code{\"shadow-type\"} of type @symbol{gtk-shadow-type} (Read) @br{}
      Style of bevel around the spin button. @br{}
      Default value: @code{:in}
  @end{dictionary}
  @begin[Signal Details]{dictionary}
    @subheading{The \"change-value\" signal}
      @begin{pre}
 lambda (spinbutton arg)   : Action
      @end{pre}
    @subheading{The \"input\" signal}
      @begin{pre}
 lambda (spin-button new-value)   : Run Last
      @end{pre}
      The \"input\" signal can be used to influence the conversion of the users
      input into a double value. The signal handler is expected to use the
      function @fun{gtk-entry-get-text} to retrieve the text of the entry and
      set new_value to the new value.
      The default conversion uses @code{g_strtod()}.
      @begin[code]{table}
        @entry[spin-button]{The object on which the signal was emitted.}
        @entry[new-value]{Return location for the new value.}
        @entry[Returns]{@em{True} for a successful conversion, @code{nil} if the
          input was not handled, and @code{GTK_INPUT_ERROR} if the conversion
          failed.}
      @end{table}
    @subheading{The \"output\" signal}
      @begin{pre}
 lambda (spin-button)   : Run Last
      @end{pre}
      The \"output\" signal can be used to change to formatting of the value
      that is displayed in the spin buttons entry.
      @begin{pre}
 /* show leading zeros */
 static gboolean
 on_output (GtkSpinButton *spin,
            gpointer       data)
 {
    GtkAdjustment *adjustment;
    gchar *text;
    int value;
    adjustment = gtk_spin_button_get_adjustment (spin);
    value = (int)gtk_adjustment_get_value (adjustment);
    text = g_strdup_printf (\"%02d\", value);
    gtk_entry_set_text (GTK_ENTRY (spin), text);
    g_free (text);

    return TRUE;
 @}
      @end{pre}
      @begin[code]{table}
        @entry[spin-button]{The object which received the signal.}
        @entry[Returns]{@em{True} if the value has been displayed.}
      @end{table}
    @subheading{The \"value-changed\" signal}
      @begin{pre}
 lambda (spinbutton)   : Run Last
      @end{pre}
    @subheading{The \"wrapped\" signal}
      @begin{pre}
 lambda (spinbutton)   : Run Last
      @end{pre}
      The wrapped signal is emitted right after the spinbutton wraps from its
      maximum to minimum value or vice-versa.
      @begin[code]{table}
        @entry[spinbutton]{The object which received the signal.}
      @end{table}
      Since 2.10
  @end{dictionary}
  @see-slot{gtk-spin-button-adjustment}
  @see-slot{gtk-spin-button-climb-rate}
  @see-slot{gtk-spin-button-digits}
  @see-slot{gtk-spin-button-numeric}
  @see-slot{gtk-spin-button-snap-to-ticks}
  @see-slot{gtk-spin-button-update-policy}
  @see-slot{gtk-spin-button-value}
  @see-slot{gtk-spin-button-wrap}")

;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "adjustment"
                                               'gtk-spin-button) 't)
 "The @code{\"adjustment\"} property of type @class{gtk-adjustment}
  (Read / Write)@br{}
  The adjustment that holds the value of the spin button.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "climb-rate"
                                               'gtk-spin-button) 't)
 "The @code{\"climb-rate\"} property of type @code{:double} (Read / Write)@br{}
  The acceleration rate when you hold down a button. @br{}
  Allowed values: >= 0@br{}
  Default value: 0")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "digits" 'gtk-spin-button) 't)
 "The @code{\"digits\"} property of type @code{:uint} (Read / Write)@br{}
  The number of decimal places to display. @br{}
  Allowed values: <= 20@br{}
  Default value: 0")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "numeric" 'gtk-spin-button) 't)
 "The @code{\"numeric\"} property of type @code{:boolean} (Read / Write)@br{}
  Whether non-numeric characters should be ignored. @br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "snap-to-ticks"
                                               'gtk-spin-button) 't)
 "The @code{\"snap-to-ticks\"} property of type @code{:boolean}
  (Read / Write)@br{}
  Whether erroneous values are automatically changed to a spin button's
  nearest step increment. @br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "update-policy"
                                               'gtk-spin-button) 't)
 "The @code{\"update-policy\"} property of type
  @symbol{gtk-spin-button-update-policy} (Read / Write)@br{}
  Whether the spin button should update always, or only when the value is
  legal. @br{}
  Default value: @code{:always}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "value" 'gtk-spin-button) 't)
 "The @code{\"value\"} property of type @code{:double} (Read / Write)@br{}
  Reads the current value, or sets a new value. @br{}
  Default value: 0")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "wrap" 'gtk-spin-button) 't)
 "The @code{\"wrap\"} property of type @code{:boolean} (Read / Write)@br{}
  Whether a spin button should wrap upon reaching its limits. @br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------
;;;
;;; Accessors of Properties
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-adjustment atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-adjustment 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"adjustment\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-climb-rate atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-climb-rate 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"climb-rate\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-digits atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-digits 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"digits\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-numeric atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-numeric 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"numeric\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-snap-to-ticks atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-snap-to-ticks 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"snap-to-ticks\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-update-policy atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-update-policy 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"update-policy\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-value atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-value 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"value\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-wrap atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-spin-button-wrap 'function)
 "@version{2013-3-23}
  Accessor of the slot @code{\"wrap\"} of the @class{gtk-spin-button}
  class.")

;;; ----------------------------------------------------------------------------
;;; enum GtkSpinButtonUpdatePolicy
;;; ----------------------------------------------------------------------------

(define-g-enum "GtkSpinButtonUpdatePolicy" gtk-spin-button-update-policy
  (:export t
   :type-initializer "gtk_spin_button_update_policy_get_type")
  (:always 0)
  (:if-valid 1))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-button-update-policy atdoc:*symbol-name-alias*) "Enum"
      (gethash 'gtk-spin-button-update-policy atdoc:*external-symbols*)
 "@version{2013-4-28}
  @begin{short}
    The spin button update policy determines whether the spin button displays
    values even if they are outside the bounds of its adjustment. See the
    function @fun{gtk-spin-button-set-update-policy}.
  @end{short}
  @begin{pre}
(define-g-enum \"GtkSpinButtonUpdatePolicy\" gtk-spin-button-update-policy
  (:export t
   :type-initializer \"gtk_spin_button_update_policy_get_type\")
  (:always 0)
  (:if-valid 1))
  @end{pre}
  @begin[code]{table}
    @entry[:always]{When refreshing your @class{gtk-spin-button}, the value is
      always displayed}
    @entry[:if-valid]{When refreshing your @class{gtk-spin-button}, the value is
      only displayed if it is valid within the bounds of the spin button's
      adjustment.}
  @end{table}
  @see-function{gtk-spin-button-set-update-policy}")

;;; ----------------------------------------------------------------------------
;;; enum GtkSpinType
;;; ----------------------------------------------------------------------------

(define-g-enum "GtkSpinType" gtk-spin-type
  (:export t
   :type-initializer "gtk_spin_type_get_type")
  (:step-forward 0)
  (:step-backward 1)
  (:page-forward 2)
  (:page-backward 3)
  (:home 4)
  (:end 5)
  (:user-defined 6))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-spin-type atdoc:*symbol-name-alias*) "Enum"
      (gethash 'gtk-spin-type atdoc:*external-symbols*)
 "@version{2013-4-28}
  @begin{short}
    The values of the @sym{gtk-spin-type} enumeration are used to specify the
    change to make in the function @fun{gtk-spin-button-spin}.
  @end{short}
  @begin{pre}
(define-g-enum \"GtkSpinType\" gtk-spin-type
  (:export t
   :type-initializer \"gtk_spin_type_get_type\")
  (:step-forward 0)
  (:step-backward 1)
  (:page-forward 2)
  (:page-backward 3)
  (:home 4)
  (:end 5)
  (:user-defined 6))
  @end{pre}
  @begin[code]{table}
    @entry[:step-forward]{Increment by the adjustments step increment.}
    @entry[:step-backward]{Decrement by the adjustments step increment.}
    @entry[:page-forward]{Increment by the adjustments page increment.}
    @entry[:page-backward]{Decrement by the adjustments page increment.}
    @entry[:home]{Go to the adjustments lower bound.}
    @entry[:end]{Go to the adjustments upper bound.}
    @entry[:user-defined]{Change by a specified amount.}
  @end{table}
  @see-function{gtk-spin-button-spin}")

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_configure ()
;;;
;;; void gtk_spin_button_configure (GtkSpinButton *spin_button,
;;;                                 GtkAdjustment *adjustment,
;;;                                 gdouble climb_rate,
;;;                                 guint digits);
;;;
;;; Changes the properties of an existing spin button. The adjustment, climb
;;; rate, and number of decimal places are all changed accordingly, after this
;;; function call.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; adjustment :
;;;     a GtkAdjustment
;;;
;;; climb_rate :
;;;     the new climb rate
;;;
;;; digits :
;;;     the number of decimal places to display in the spin button
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_new ()
;;;
;;; GtkWidget * gtk_spin_button_new (GtkAdjustment *adjustment,
;;;                                  gdouble climb_rate,
;;;                                  guint digits);
;;;
;;; Creates a new GtkSpinButton.
;;;
;;; adjustment :
;;;     the GtkAdjustment object that this spin button should use, or NULL
;;;
;;; climb_rate :
;;;     specifies how much the spin button changes when an arrow is clicked on
;;;
;;; digits :
;;;     the number of decimal places to display
;;;
;;; Returns :
;;;     The new spin button as a GtkWidget
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_new_with_range ()
;;;
;;; GtkWidget * gtk_spin_button_new_with_range (gdouble min,
;;;                                             gdouble max,
;;;                                             gdouble step);
;;;
;;; This is a convenience constructor that allows creation of a numeric
;;; GtkSpinButton without manually creating an adjustment. The value is
;;; initially set to the minimum value and a page increment of 10 * step is the
;;; default. The precision of the spin button is equivalent to the precision of
;;; step.
;;;
;;; Note that the way in which the precision is derived works best if step is a
;;; power of ten. If the resulting precision is not suitable for your needs, use
;;; gtk_spin_button_set_digits() to correct it.
;;;
;;; min :
;;;     Minimum allowable value
;;;
;;; max :
;;;     Maximum allowable value
;;;
;;; step :
;;;     Increment added or subtracted by spinning the widget
;;;
;;; Returns :
;;;     The new spin button as a GtkWidget
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_adjustment ()
;;;
;;; void gtk_spin_button_set_adjustment (GtkSpinButton *spin_button,
;;;                                      GtkAdjustment *adjustment);
;;;
;;; Replaces the GtkAdjustment associated with spin_button.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; adjustment :
;;;     a GtkAdjustment to replace the existing adjustment
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_adjustment ()
;;;
;;; GtkAdjustment * gtk_spin_button_get_adjustment (GtkSpinButton *spin_button);
;;;
;;; Get the adjustment associated with a GtkSpinButton
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; Returns :
;;;     the GtkAdjustment of spin_button
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_digits ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-set-digits))

(defun gtk-spin-button-set-digits (spin-button digits)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @argument[digits]{the number of digits after the decimal point to be displayed
    for the spin button's value}
  Set the precision to be displayed by @arg{spin-button}. Up to 20 digit
  precision is allowed."
  (setf (gtk-spin-button-digits spin-button) digits))

(export 'gtk-spin-button-set-digits)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_increments ()
;;;
;;; void gtk_spin_button_set_increments (GtkSpinButton *spin_button,
;;;                                      gdouble step,
;;;                                      gdouble page);
;;;
;;; Sets the step and page increments for spin_button. This affects how quickly
;;; the value changes when the spin button's arrows are activated.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; step :
;;;     increment applied for a button 1 press.
;;;
;;; page :
;;;     increment applied for a button 2 press.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_range ()
;;;
;;; void gtk_spin_button_set_range (GtkSpinButton *spin_button,
;;;                                 gdouble min,
;;;                                 gdouble max);
;;;
;;; Sets the minimum and maximum allowable values for spin_button.
;;;
;;; If the current value is outside this range, it will be adjusted to fit
;;; within the range, otherwise it will remain unchanged.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; min :
;;;     minimum allowable value
;;;
;;; max :
;;;     maximum allowable value
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_value_as_int ()
;;; ----------------------------------------------------------------------------

(defun gtk-spin-button-get-value-as-int (spin-button)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @return{The value of @arg{spin-button}.}
  Get the value @arg{spin-button} represented as an integer."
  (truncate (gtk-spin-button-value spin-button)))

(export 'gtk-spin-button-get-value-as-int)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_value ()
;;;
;;; void gtk_spin_button_set_value (GtkSpinButton *spin_button, gdouble value);
;;;
;;; Sets the value of spin_button.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; value :
;;;     the new value
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_update_policy ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-set-update-policy))

(defun gtk-spin-button-set-update-policy (spin-button policy)
 #+cl-cffi-gtk-documentation
 "@version{2013-5-20}
  @argument[spin-button]{a @class{gtk-spin-button} object}
  @argument[policy]{a @symbol{gtk-spin-button-update-policy} value}
  Sets the update behavior of a spin button. This determines wether the spin
  button is always updated or only when a valid value is set."
  (setf (gtk-spin-button-update-policy spin-button) policy))

(export 'gtk-spin-button-set-update-policy)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_numeric ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-set-numeric))

(defun gtk-spin-button-set-numeric (spin-button numeric)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @argument[numeric]{flag indicating if only numeric entry is allowed}
  Sets the flag that determines if non-numeric text can be typed into the spin
  button."
  (setf (gtk-spin-button-numeric spin-button) numeric))

(export 'gtk-spin-button-set-numeric)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_spin ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_spin_button_spin" gtk-spin-button-spin) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @argument[direction]{a @class{gtk-spin-type} indicating the direction to spin}
  @argument[increment]{step increment to apply in the specified direction}
  Increment or decrement a spin button's value in a specified direction by a
  specified amount."
  (spin-button (g-object gtk-spin-button))
  (direction gtk-spin-type)
  (increment :double))

(export 'gtk-spin-button-spin)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_wrap ()
;;;
;;; void gtk_spin_button_set_wrap (GtkSpinButton *spin_button, gboolean wrap);
;;;
;;; Sets the flag that determines if a spin button value wraps around to the
;;; opposite limit when the upper or lower limit of the range is exceeded.
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; wrap :
;;;     a flag indicating if wrapping behavior is performed
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_set_snap_to_ticks ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-set-snap-to-ticks))

(defun gtk-spin-button-set-snap-to-ticks (spin-button snap-to-ticks)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @argument[snap-to-ticks]{a flag indicating if invalid values should be
    corrected}
  Sets the policy as to whether values are corrected to the nearest step
  increment when a spin button is activated after providing an invalid value."
  (setf (gtk-spin-button-snap-to-ticks spin-button) snap-to-ticks))

(export 'gtk-spin-button-set-snap-to-ticks)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_update ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_spin_button_update" gtk-spin-button-update) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  Manually force an update of the spin button."
  (spin-button (g-object gtk-spin-button)))

(export 'gtk-spin-button-update)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_digits ()
;;;
;;; guint gtk_spin_button_get_digits (GtkSpinButton *spin_button);
;;;
;;; Fetches the precision of spin_button. See gtk_spin_button_set_digits().
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; Returns :
;;;     the current precision
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_increments ()
;;;
;;; void gtk_spin_button_get_increments (GtkSpinButton *spin_button,
;;;                                      gdouble *step,
;;;                                      gdouble *page);
;;;
;;; Gets the current step and page the increments used by spin_button. See
;;; gtk_spin_button_set_increments().
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; step :
;;;     location to store step increment, or NULL
;;;
;;; page :
;;;     location to store page increment, or NULL
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_numeric ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-get-numeric))

(defun gtk-spin-button-get-numeric (spin-button)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @return{@em{True} if only numeric text can be entered.}
  Returns whether non-numeric text can be typed into the spin button.
  See the function @fun{gtk-spin-button-set-numeric}.
  @see-function{gtk-spin-button-set-numeric}"
  (gtk-spin-button-numeric spin-button))

(export 'gtk-spin-button-get-numeric)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_range ()
;;;
;;; void gtk_spin_button_get_range (GtkSpinButton *spin_button,
;;;                                 gdouble *min,
;;;                                 gdouble *max);
;;;
;;; Gets the range allowed for spin_button. See gtk_spin_button_set_range().
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; min :
;;;     location to store minimum allowed value, or NULL
;;;
;;; max :
;;;     location to store maximum allowed value, or NULL
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_snap_to_ticks ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-get-snap-to-ticks))

(defun gtk-spin-button-get-snap-to-ticks (spin-button)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @return{@em{True} if values are snapped to the nearest step.}
  Returns whether the values are corrected to the nearest step. See the
  function @fun{gtk-spin-button-set-snap-to-ticks}.
  @see-function{gtk-spin-button-set-snap-to-ticks}"
  (gtk-spin-button-snap-to-ticks spin-button))

(export 'gtk-spin-button-get-snap-to-ticks)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_update_policy ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-get-update-policy))

(defun gtk-spin-button-get-update-policy (spin-button)
 #+cl-cffi-gtk-documentation
 "@version{2013-5-20}
  @argument[spin-button]{a @class{gtk-spin-button} object}
  @return{The current update policy.}
  Gets the update behavior of a spin button. See the function
  @fun{gtk-spin-button-set-update-policy}.
  @see-function{gtk-spin-button-set-update-policy}"
  (gtk-spin-button-update-policy spin-button))

(export 'gtk-spin-button-get-update-policy)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_value ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-spin-button-get-value))

(defun gtk-spin-button-get-value (spin-button)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-28}
  @argument[spin-button]{a @class{gtk-spin-button} widget}
  @return{The value of @arg{spin-button}.}
  Get the value in the @arg{spin-button}."
  (gtk-spin-button-value spin-button))

(export 'gtk-spin-button-get-value)

;;; ----------------------------------------------------------------------------
;;; gtk_spin_button_get_wrap ()
;;;
;;; gboolean gtk_spin_button_get_wrap (GtkSpinButton *spin_button);
;;;
;;; Returns whether the spin button's value wraps around to the opposite limit
;;; when the upper or lower limit of the range is exceeded. See
;;; gtk_spin_button_set_wrap().
;;;
;;; spin_button :
;;;     a GtkSpinButton
;;;
;;; Returns :
;;;     TRUE if the spin button wraps around
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; GTK_INPUT_ERROR
;;;
;;; #define GTK_INPUT_ERROR -1
;;;
;;; Constant to return from a signal handler for the "input" signal in case of
;;; conversion failure.
;;; ----------------------------------------------------------------------------

;;; --- End of file gtk.spin-button.lisp ---------------------------------------
