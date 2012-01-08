;;; ----------------------------------------------------------------------------
;;; gdk.threads.lisp
;;;
;;; Copyright (C) 2009, 2011 Kalyanov Dmitry
;;; Copyright (C) 2011, 2012 Dr. Dieter Kaiser
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See http://common-lisp.net/project/cl-gtk2/
;;;
;;; The documentation has been copied from the GDK 2 Reference Manual
;;; See http://www.gtk.org
;;;
;;; ----------------------------------------------------------------------------
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
;;; Threads
;;; 
;;; Functions for using GDK in multi-threaded programs
;;; 	
;;; Synopsis
;;; 
;;;     GDK_THREADS_ENTER
;;;     GDK_THREADS_LEAVE
;;;     gdk_threads_init
;;;     gdk_threads_enter
;;;     gdk_threads_leave
;;;     GMutex *gdk_threads_mutex
;;;     gdk_threads_set_lock_functions
;;;     gdk_threads_add_idle
;;;     gdk_threads_add_idle_full
;;;     gdk_threads_add_timeout
;;;     gdk_threads_add_timeout_full
;;;     gdk_threads_add_timeout_seconds
;;;     gdk_threads_add_timeout_seconds_full
;;; 
;;; Description
;;; 
;;; For thread safety, GDK relies on the thread primitives in GLib, and on the
;;; thread-safe GLib main loop.
;;; 
;;; GLib is completely thread safe (all global data is automatically locked),
;;; but individual data structure instances are not automatically locked for
;;; performance reasons. So e.g. you must coordinate accesses to the same
;;; GHashTable from multiple threads.
;;; 
;;; GTK+ is "thread aware" but not thread safe — it provides a global lock
;;; controlled by gdk_threads_enter()/gdk_threads_leave() which protects all
;;; use of GTK+. That is, only one thread can use GTK+ at any given time.
;;; 
;;; Unfortunately the above holds with the X11 backend only. With the Win32
;;; backend, GDK calls should not be attempted from multiple threads at all.
;;; 
;;; You must call g_thread_init() and gdk_threads_init() before executing any
;;; other GTK+ or GDK functions in a threaded GTK+ program.
;;; 
;;; Idles, timeouts, and input functions from GLib, such as g_idle_add(), are
;;; executed outside of the main GTK+ lock. So, if you need to call GTK+ inside
;;; of such a callback, you must surround the callback with a
;;; gdk_threads_enter()/gdk_threads_leave() pair or use
;;; gdk_threads_add_idle_full() which does this for you. However, event
;;; dispatching from the mainloop is still executed within the main GTK+ lock,
;;; so callback functions connected to event signals like
;;; GtkWidget::button-press-event, do not need thread protection.
;;; 
;;; In particular, this means, if you are writing widgets that might be used in
;;; threaded programs, you must surround timeouts and idle functions in this
;;; matter.
;;; 
;;; As always, you must also surround any calls to GTK+ not made within a
;;; signal handler with a gdk_threads_enter()/gdk_threads_leave() pair.
;;; 
;;; Before calling gdk_threads_leave() from a thread other than your main
;;; thread, you probably want to call gdk_flush() to send all pending commands
;;; to the windowing system. (The reason you don't need to do this from the
;;; main thread is that GDK always automatically flushes pending commands when
;;; it runs out of incoming events to process and has to sleep while waiting
;;; for more events.)
;;; 
;;; A minimal main program for a threaded GTK+ application looks like:
;;; 
;;; int
;;; main (int argc, char *argv[])
;;; {
;;;   GtkWidget *window;
;;;   g_thread_init (NULL);
;;;   gdk_threads_init ();
;;;   gdk_threads_enter ();
;;;   gtk_init (&argc, &argv);
;;;   window = create_window ();
;;;   gtk_widget_show (window);
;;;   gtk_main ();
;;;   gdk_threads_leave ();
;;;   return 0;
;;; }
;;; 
;;; Callbacks require a bit of attention. Callbacks from GTK+ signals are made
;;; within the GTK+ lock. However callbacks from GLib (timeouts, IO callbacks,
;;; and idle functions) are made outside of the GTK+ lock. So, within a signal
;;; handler you do not need to call gdk_threads_enter(), but within the other
;;; types of callbacks, you do.
;;; 
;;; Erik Mouw contributed the following code example to illustrate how to use
;;; threads within GTK+ programs.
;;; 
;;; /*-------------------------------------------------------------------------
;;;  * Filename:      gtk-thread.c
;;;  * Version:       0.99.1
;;;  * Copyright:     Copyright (C) 1999, Erik Mouw
;;;  * Author:        Erik Mouw <J.A.K.Mouw@its.tudelft.nl>
;;;  * Description:   GTK threads example.
;;;  * Created at:    Sun Oct 17 21:27:09 1999
;;;  * Modified by:   Erik Mouw <J.A.K.Mouw@its.tudelft.nl>
;;;  * Modified at:   Sun Oct 24 17:21:41 1999
;;;  *-----------------------------------------------------------------------*/
;;; /*
;;;  * Compile with:
;;;  *
;;;  * cc -o gtk-thread gtk-thread.c `gtk-config --cflags --libs gthread`
;;;  *
;;;  * Thanks to Sebastian Wilhelmi and Owen Taylor for pointing out some
;;;  * bugs.
;;;  *
;;;  */
;;; #include <stdio.h>
;;; #include <stdlib.h>
;;; #include <unistd.h>
;;; #include <time.h>
;;; #include <gtk/gtk.h>
;;; #include <glib.h>
;;; #include <pthread.h>
;;; #define YES_IT_IS    (1)
;;; #define NO_IT_IS_NOT (0)
;;; typedef struct
;;; {
;;;   GtkWidget *label;
;;;   int what;
;;; } yes_or_no_args;
;;; G_LOCK_DEFINE_STATIC (yes_or_no);
;;; static volatile int yes_or_no = YES_IT_IS;
;;; void destroy (GtkWidget *widget, gpointer data)
;;; {
;;;   gtk_main_quit ();
;;; }
;;; void *argument_thread (void *args)
;;; {
;;;   yes_or_no_args *data = (yes_or_no_args *)args;
;;;   gboolean say_something;
;;;   for (;;)
;;;     {
;;;       /* sleep a while */
;;;       sleep(rand() / (RAND_MAX / 3) + 1);
;;;       /* lock the yes_or_no_variable */
;;;       G_LOCK(yes_or_no);
;;;       /* do we have to say something? */
;;;       say_something = (yes_or_no != data->what);
;;;       if(say_something)
;;;     {
;;;       /* set the variable */
;;;       yes_or_no = data->what;
;;;     }
;;;       /* Unlock the yes_or_no variable */
;;;       G_UNLOCK (yes_or_no);
;;;       if (say_something)
;;;     {
;;;       /* get GTK thread lock */
;;;       gdk_threads_enter ();
;;;       /* set label text */
;;;       if(data->what == YES_IT_IS)
;;;         gtk_label_set_text (GTK_LABEL (data->label), "O yes, it is!");
;;;       else
;;;         gtk_label_set_text (GTK_LABEL (data->label), "O no, it isn't!");
;;;       /* release GTK thread lock */
;;;       gdk_threads_leave ();
;;;     }
;;;     }
;;;   return NULL;
;;; }
;;; int main (int argc, char *argv[])
;;; {
;;;   GtkWidget *window;
;;;   GtkWidget *label;
;;;   yes_or_no_args yes_args, no_args;
;;;   pthread_t no_tid, yes_tid;
;;;   /* init threads */
;;;   g_thread_init (NULL);
;;;   gdk_threads_init ();
;;;   gdk_threads_enter ();
;;;   /* init gtk */
;;;   gtk_init(&argc, &argv);
;;;   /* init random number generator */
;;;   srand ((unsigned int) time (NULL));
;;;   /* create a window */
;;;   window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
;;;   g_signal_connect (window, "destroy", G_CALLBACK (destroy), NULL);
;;;   gtk_container_set_border_width (GTK_CONTAINER (window), 10);
;;;   /* create a label */
;;;   label = gtk_label_new ("And now for something completely different ...");
;;;   gtk_container_add (GTK_CONTAINER (window), label);
;;;   /* show everything */
;;;   gtk_widget_show (label);
;;;   gtk_widget_show (window);
;;;   /* create the threads */
;;;   yes_args.label = label;
;;;   yes_args.what = YES_IT_IS;
;;;   pthread_create (&yes_tid, NULL, argument_thread, &yes_args);
;;;   no_args.label = label;
;;;   no_args.what = NO_IT_IS_NOT;
;;;   pthread_create (&no_tid, NULL, argument_thread, &no_args);
;;;   /* enter the GTK main loop */
;;;   gtk_main ();
;;;   gdk_threads_leave ();
;;;   return 0;
;;; }
;;; ----------------------------------------------------------------------------

(in-package :gdk)

;;; ----------------------------------------------------------------------------

(defmacro with-gdk-threads-lock (&body body)
  `(progn
     (gdk-threads-enter)
     (unwind-protect
          (progn ,@body)
       (gdk-threads-leave))))

(export 'with-gdk-threads-lock)

;;; ----------------------------------------------------------------------------

(defcallback source-func-callback :boolean
    ((data :pointer))
  (funcall (stable-pointer-value data)))

(defcallback stable-pointer-free-destroy-notify-callback :void ((data :pointer))
  (free-stable-pointer data))

;;; ----------------------------------------------------------------------------
;;; GDK_THREADS_ENTER
;;; 
;;; #define GDK_THREADS_ENTER()
;;; 
;;; This macro marks the beginning of a critical section in which GDK and GTK+
;;; functions can be called safely and without causing race conditions. Only
;;; one thread at a time can be in such a critial section. The macro expands to
;;; a no-op if G_THREADS_ENABLED has not been defined. Typically
;;; gdk_threads_enter() should be used instead of this macro.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; GDK_THREADS_LEAVE
;;; 
;;; #define GDK_THREADS_LEAVE()
;;; 
;;; This macro marks the end of a critical section begun with GDK_THREADS_ENTER.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_init ()
;;; 
;;; void gdk_threads_init (void);
;;; 
;;; Initializes GDK so that it can be used from multiple threads in conjunction
;;; with gdk_threads_enter() and gdk_threads_leave(). g_thread_init() must be
;;; called previous to this function.
;;; 
;;; This call must be made before any use of the main loop from GTK+; to be
;;; safe, call it before gtk_init().
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_init" gdk-threads-init) :void)

(glib:at-init () (gdk-threads-init))

;;; ----------------------------------------------------------------------------
;;; gdk_threads_enter ()
;;; 
;;; void gdk_threads_enter (void);
;;; 
;;; This macro marks the beginning of a critical section in which GDK and GTK+
;;; functions can be called safely and without causing race conditions. Only
;;; one thread at a time can be in such a critial section.
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_enter" gdk-threads-enter) :void)

(export 'gdk-threads-enter)

;;; ----------------------------------------------------------------------------
;;; gdk_threads_leave ()
;;; 
;;; void gdk_threads_leave (void);
;;; 
;;; Leaves a critical region begun with gdk_threads_enter().
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_leave" gdk-threads-leave) :void)

(export 'gdk-threads-leave)

;;; ----------------------------------------------------------------------------
;;; gdk_threads_mutex
;;; 
;;; extern GMutex *gdk_threads_mutex; /* private */
;;; 
;;; Warning
;;; 
;;; gdk_threads_mutex is deprecated and should not be used in newly-written
;;; code.
;;; 
;;; The GMutex used to implement the critical region for
;;; gdk_threads_enter()/gdk_threads_leave().
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_set_lock_functions ()
;;; 
;;; void gdk_threads_set_lock_functions (GCallback enter_fn, GCallback leave_fn)
;;; 
;;; Allows the application to replace the standard method that GDK uses to
;;; protect its data structures. Normally, GDK creates a single GMutex that is
;;; locked by gdk_threads_enter(), and released by gdk_threads_leave(); using
;;; this function an application provides, instead, a function enter_fn that is
;;; called by gdk_threads_enter() and a function leave_fn that is called by
;;; gdk_threads_leave().
;;; 
;;; The functions must provide at least same locking functionality as the
;;; default implementation, but can also do extra application specific
;;; processing.
;;; 
;;; As an example, consider an application that has its own recursive lock that
;;; when held, holds the GTK+ lock as well. When GTK+ unlocks the GTK+ lock
;;; when entering a recursive main loop, the application must temporarily
;;; release its lock as well.
;;; 
;;; Most threaded GTK+ apps won't need to use this method.
;;; 
;;; This method must be called before gdk_threads_init(), and cannot be called
;;; multiple times.
;;; 
;;; enter_fn :
;;; 	function called to guard GDK
;;; 
;;; leave_fn :
;;; 	function called to release the guard
;;; 
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_idle ()
;;; 
;;; guint gdk_threads_add_idle (GSourceFunc function, gpointer data);
;;; 
;;; A wrapper for the common usage of gdk_threads_add_idle_full() assigning the
;;; default priority, G_PRIORITY_DEFAULT_IDLE.
;;; 
;;; See gdk_threads_add_idle_full().
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_idle_full ()
;;; 
;;; guint gdk_threads_add_idle_full (gint priority,
;;;                                  GSourceFunc function,
;;;                                  gpointer data,
;;;                                  GDestroyNotify notify);
;;; 
;;; Adds a function to be called whenever there are no higher priority events
;;; pending. If the function returns FALSE it is automatically removed from the
;;; list of event sources and will not be called again.
;;; 
;;; This variant of g_idle_add_full() calls function with the GDK lock held. It
;;; can be thought of a MT-safe version for GTK+ widgets for the following use
;;; case, where you have to worry about idle_callback() running in thread A and
;;; accessing self after it has been finalized in thread B:
;;; 
;;; static gboolean
;;; idle_callback (gpointer data)
;;; {
;;;    /* gdk_threads_enter(); would be needed for g_idle_add() */
;;; 
;;;    SomeWidget *self = data;
;;;    /* do stuff with self */
;;; 
;;;    self->idle_id = 0;
;;; 
;;;    /* gdk_threads_leave(); would be needed for g_idle_add() */
;;;    return FALSE;
;;; }
;;; 
;;; static void
;;; some_widget_do_stuff_later (SomeWidget *self)
;;; {
;;;    self->idle_id = gdk_threads_add_idle (idle_callback, self)
;;;    /* using g_idle_add() would require thread protection in the callback */
;;; }
;;; 
;;; static void
;;; some_widget_finalize (GObject *object)
;;; {
;;;    SomeWidget *self = SOME_WIDGET (object);
;;;    if (self->idle_id)
;;;      g_source_remove (self->idle_id);
;;;    G_OBJECT_CLASS (parent_class)->finalize (object);
;;; }
;;; 
;;; priority :
;;; 	the priority of the idle source. Typically this will be in the range
;;;     btweeen G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; notify :
;;; 	function to call when the idle is removed, or NULL. [allow-none]
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.12
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_add_idle_full" %gdk_threads_add_idle_full) :uint
  (priority :int)
  (function :pointer)
  (data :pointer)
  (notify :pointer))

(defun gdk-threads-add-idle-full (priority function)
  (%gdk-threads-add-idle-full priority
                              (callback source-func-callback)
                              (allocate-stable-pointer function)
                              (callback stable-pointer-free-destroy-notify-callback)))

(export 'gdk-threads-add-idle-full)

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_timeout ()
;;; 
;;; guint gdk_threads_add_timeout (guint interval,
;;;                                GSourceFunc function,
;;;                                gpointer data);
;;; 
;;; A wrapper for the common usage of gdk_threads_add_timeout_full() assigning
;;; the default priority, G_PRIORITY_DEFAULT.
;;; 
;;; See gdk_threads_add_timeout_full().
;;; 
;;; interval :
;;; 	the time between calls to the function, in milliseconds (1/1000ths of
;;;     a second)
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_timeout_full ()
;;; 
;;; guint gdk_threads_add_timeout_full (gint priority,
;;;                                     guint interval,
;;;                                     GSourceFunc function,
;;;                                     gpointer data,
;;;                                     GDestroyNotify notify);
;;; 
;;; Sets a function to be called at regular intervals holding the GDK lock,
;;; with the given priority. The function is called repeatedly until it returns
;;; FALSE, at which point the timeout is automatically destroyed and the
;;; function will not be called again. The notify function is called when the
;;; timeout is destroyed. The first call to the function will be at the end of
;;; the first interval.
;;; 
;;; Note that timeout functions may be delayed, due to the processing of other
;;; event sources. Thus they should not be relied on for precise timing. After
;;; each call to the timeout function, the time of the next timeout is
;;; recalculated based on the current time and the given interval (it does not
;;; try to 'catch up' time lost in delays).
;;; 
;;; This variant of g_timeout_add_full() can be thought of a MT-safe version
;;; for GTK+ widgets for the following use case:
;;; 
;;; static gboolean timeout_callback (gpointer data)
;;; {
;;;    SomeWidget *self = data;
;;;    
;;;    /* do stuff with self */
;;;    
;;;    self->timeout_id = 0;
;;;    
;;;    return FALSE;
;;; }
;;;  
;;; static void some_widget_do_stuff_later (SomeWidget *self)
;;; {
;;;    self->timeout_id = g_timeout_add (timeout_callback, self)
;;; }
;;;  
;;; static void some_widget_finalize (GObject *object)
;;; {
;;;    SomeWidget *self = SOME_WIDGET (object);
;;;    
;;;    if (self->timeout_id)
;;;      g_source_remove (self->timeout_id);
;;;    
;;;    G_OBJECT_CLASS (parent_class)->finalize (object);
;;; }
;;; 
;;; priority :
;;; 	the priority of the timeout source. Typically this will be in the
;;;     range between G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE.
;;; 
;;; interval :
;;; 	the time between calls to the function, in milliseconds
;;;     (1/1000ths of a second)
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; notify :
;;; 	function to call when the timeout is removed, or NULL. [allow-none]
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.12
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_add_timeout_full" %gdk-threads-add-timeout-full) :uint
  (priority :int)
  (interval :uint)
  (function :pointer)
  (data :pointer)
  (notify :pointer))

(defun gdk-threads-add-timeout-full (priority interval function)
  (%gdk-threads-add-timeout-full priority
                                 interval
                                 (callback source-func-callback)
                                 (allocate-stable-pointer function)
                                 (callback stable-pointer-free-destroy-notify-callback)))

(export 'gdk-threads-add-timeout-full)

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_timeout_seconds ()
;;; 
;;; guint gdk_threads_add_timeout_seconds (guint interval,
;;;                                        GSourceFunc function,
;;;                                        gpointer data);
;;; 
;;; A wrapper for the common usage of gdk_threads_add_timeout_seconds_full()
;;; assigning the default priority, G_PRIORITY_DEFAULT.
;;; 
;;; For details, see gdk_threads_add_timeout_full().
;;; 
;;; interval :
;;; 	the time between calls to the function, in seconds
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gdk_threads_add_timeout_seconds_full ()
;;; 
;;; guint gdk_threads_add_timeout_seconds_full (gint priority,
;;;                                             guint interval,
;;;                                             GSourceFunc function,
;;;                                             gpointer data,
;;;                                             GDestroyNotify notify);
;;; 
;;; A variant of gdk_threads_add_timout_full() with second-granularity. See
;;; g_timeout_add_seconds_full() for a discussion of why it is a good idea to
;;; use this function if you don't need finer granularity.
;;; 
;;; priority :
;;; 	the priority of the timeout source. Typically this will be in the range
;;;     between G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE.
;;; 
;;; interval :
;;; 	the time between calls to the function, in seconds
;;; 
;;; function :
;;; 	function to call
;;; 
;;; data :
;;; 	data to pass to function
;;; 
;;; notify :
;;; 	function to call when the timeout is removed, or NULL. [allow-none]
;;; 
;;; Returns :
;;; 	the ID (greater than 0) of the event source.
;;; 
;;; Since 2.14
;;; ----------------------------------------------------------------------------

(defcfun ("gdk_threads_add_timeout_seconds_full"
          %gdk-threads-add-timeout-seconds-full) :uint
  (priority :int)
  (interval :uint)
  (function :pointer)
  (data :pointer)
  (notify :pointer))

(defun gdk-threads-add-timeout-seconds-full (priority interval function)
  (%gdk-threads-add-timeout-seconds-full priority
                                         interval
                                         (callback source-func-callback)
                                         (allocate-stable-pointer function)
                                         (callback stable-pointer-free-destroy-notify-callback)))

(export 'gdk-threads-add-timeout-seconds-full)

;;; --- End of file gdk.threads.lisp -------------------------------------------
