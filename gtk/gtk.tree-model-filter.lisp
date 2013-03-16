;;; ----------------------------------------------------------------------------
;;; gtk.tree-model-filter.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See <http://common-lisp.net/project/cl-gtk2/>.
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.3. See <http://www.gtk.org>. The API documentation of the
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
;;; GtkTreeModelFilter
;;;
;;; A GtkTreeModel which hides parts of an underlying tree model
;;;
;;; Synopsis
;;;
;;;     GtkTreeModelFilter
;;;
;;;     gtk_tree_model_filter_new
;;;     gtk_tree_model_filter_set_visible_func
;;;     gtk_tree_model_filter_set_modify_func
;;;     gtk_tree_model_filter_set_visible_column
;;;     gtk_tree_model_filter_get_model
;;;     gtk_tree_model_filter_convert_child_iter_to_iter
;;;     gtk_tree_model_filter_convert_iter_to_child_iter
;;;     gtk_tree_model_filter_convert_child_path_to_path
;;;     gtk_tree_model_filter_convert_path_to_child_path
;;;     gtk_tree_model_filter_refilter
;;;     gtk_tree_model_filter_clear_cache
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkTreeModelFilter
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkTreeModelFilter" gtk-tree-model-filter
  (:superclass g-object
   :export t
   :interfaces ("GtkTreeDragSource" "GtkTreeModel")
   :type-initializer "gtk_tree_model_filter_get_type")
  ((child-model
    gtk-tree-model-filter-child-model
    "child-model" "GtkTreeModel" t nil)
   (virtual-root
    gtk-tree-model-filter-virtual-root
    "virtual-root" "GtkTreePath" t nil)))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-tree-model-filter 'type)
 "@version{2013-3-10}
  @begin{short}
    A @sym{gtk-tree-model-filter} is a tree model which wraps another tree
    model.
  @end{short}
  @sym{gtk-tree-model-filter} can do the following things:
  @begin{itemize}
    @begin{item}
      Filter specific rows, based on data from a \"visible column\", a column
      storing booleans indicating whether the row should be filtered or not,
      or based on the return value of a \"visible function\", which gets a
      model, iter and user_data and returns a boolean indicating whether the
      row should be filtered or not.
    @end{item}
    @begin{item}
      Modify the \"appearance\" of the model, using a modify function. This is
      extremely powerful and allows for just changing some values and also for
      creating a completely different model based on the given child model.
    @end{item}
    @begin{item}
      Set a different root node, also known as a \"virtual root\". You can pass
      in a GtkTreePath indicating the root node for the filter at construction
      time.
    @end{item}
  @end{itemize}
  The basic API is similar to GtkTreeModelSort. For an example on its usage,
  see the section on GtkTreeModelSort.

  When using GtkTreeModelFilter, it is important to realize that
  GtkTreeModelFilter maintains an internal cache of all nodes which are
  visible in its clients. The cache is likely to be a subtree of the tree
  exposed by the child model. GtkTreeModelFilter will not cache the entire
  child model when unnecessary to not compromise the caching mechanism that is
  exposed by the reference counting scheme. If the child model implements
  reference counting, unnecessary signals may not be emitted because of
  reference counting rule 3, see the GtkTreeModel documentation. (Note that
  e.g. GtkTreeStore does not implement reference counting and will always emit
  all signals, even when the receiving node is not visible).

  Because of this, limitations for possible visible functions do apply. In
  general, visible functions should only use data or properties from the node
  for which the visibility state must be determined, its siblings or its
  parents. Usually, having a dependency on the state of any child node is not
  possible, unless references are taken on these explicitly. When no such
  reference exists, no signals may be received for these child nodes (see
  reference couting rule number 3 in the GtkTreeModel section).

  Determining the visibility state of a given node based on the state of its
  child nodes is a frequently occurring use case. Therefore,
  GtkTreeModelFilter explicitly supports this. For example, when a node does
  not have any children, you might not want the node to be visible. As soon as
  the first row is added to the node's child level (or the last row removed),
  the node's visibility should be updated.

  This introduces a dependency from the node on its child nodes. In order to
  accommodate this, GtkTreeModelFilter must make sure the necesary signals are
  received from the child model. This is achieved by building, for all nodes
  which are exposed as visible nodes to GtkTreeModelFilter's clients, the
  child level (if any) and take a reference on the first node in this level.
  Furthermore, for every row-inserted, row-changed or row-deleted signal (also
  these which were not handled because the node was not cached),
  GtkTreeModelFilter will check if the visibility state of any parent node has
  changed.

  Beware, however, that this explicit support is limited to these two cases.
  For example, if you want a node to be visible only if two nodes in a child's
  child level (2 levels deeper) are visible, you are on your own. In this
  case, either rely on GtkTreeStore to emit all signals because it does not
  implement reference counting, or for models that do implement reference
  counting, obtain references on these child levels yourself.
  @see-slot{gtk-tree-model-filter-child-model}
  @see-slot{gtk-tree-model-filter-virtual-root}")

;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "child-model"
                                               'gtk-tree-model-filter) 't)
 "The @code{\"child-model\"} property of type @class{gtk-tree-model}
  (Read / Write / Construct)@br{}
  The model for the filtermodel to filter.")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "virtual-root"
                                               'gtk-tree-model-filter) 't)
 "The @code{\"virtual-root\"} property of type @class{gtk-tree-path}
  (Read / Write / Construct)@br{}
  The virtual root (relative to the child model) for this filtermodel.")

;;; ----------------------------------------------------------------------------
;;;
;;; Accessors
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-tree-model-filter-child-model atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-tree-model-filter-child-model 'function)
 "@version{2013-3-10}
  @begin{short}
    Accessor of the slot @code{\"child-model\"} of the
    @class{gtk-tree-model-filter} class.
  @end{short}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-tree-model-filter-virtual-root atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-tree-model-filter-virtual-root 'function)
 "@version{2013-3-10}
  @begin{short}
    Accessor of the slot @code{\"virtual-root\"} of the
    @class{gtk-tree-model-filter} class.
  @end{short}")

;;; ----------------------------------------------------------------------------
;;; GtkTreeModelFilterVisibleFunc ()
;;;
;;; gboolean (*GtkTreeModelFilterVisibleFunc) (GtkTreeModel *model,
;;;                                            GtkTreeIter *iter,
;;;                                            gpointer data);
;;;
;;; A function which decides whether the row indicated by iter is visible.
;;;
;;; model :
;;;     the child model of the GtkTreeModelFilter
;;;
;;; iter :
;;;     a GtkTreeIter pointing to the row in model whose visibility is
;;;     determined
;;;
;;; data :
;;;     user data given to gtk_tree_model_filter_set_visible_func()
;;;
;;; Returns :
;;;     Whether the row indicated by iter is visible.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; GtkTreeModelFilterModifyFunc ()
;;;
;;; void (*GtkTreeModelFilterModifyFunc) (GtkTreeModel *model,
;;;                                       GtkTreeIter *iter,
;;;                                       GValue *value,
;;;                                       gint column,
;;;                                       gpointer data);
;;;
;;; A function which calculates display values from raw values in the model. It
;;; must fill value with the display value for the column column in the row
;;; indicated by iter.
;;;
;;; Since this function is called for each data access, it's not a particularly
;;; efficient operation.
;;;
;;; model :
;;;     the GtkTreeModelFilter
;;;
;;; iter :
;;;     a GtkTreeIter pointing to the row whose display values are determined
;;;
;;; value :
;;;     A GValue which is already initialized for with the correct type for the
;;;     column column.
;;;
;;; column :
;;;     the column whose display value is determined
;;;
;;; data :
;;;     user data given to gtk_tree_model_filter_set_modify_func()
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_new ()
;;;
;;; GtkTreeModel * gtk_tree_model_filter_new (GtkTreeModel *child_model,
;;;                                           GtkTreePath *root);
;;;
;;; Creates a new GtkTreeModel, with child_model as the child_model and root as
;;; the virtual root.
;;;
;;; child_model :
;;;     A GtkTreeModel.
;;;
;;; root :
;;;     A GtkTreePath or NULL.
;;;
;;; Returns :
;;;     A new GtkTreeModel.
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_set_visible_func ()
;;; ----------------------------------------------------------------------------

(defcallback gtk-tree-model-filter-visible-func-callback :boolean
  ((tree-model g-object) (iter (g-boxed-foreign gtk-tree-iter)) (data :pointer))
  (let ((fn (glib::get-stable-pointer-value data)))
    (restart-case
        (funcall fn tree-model iter)
      (return-true () t)
      (return-false () nil))))

(defcfun ("gtk_tree_model_filter_set_visible_func"
          %gtk-tree-model-filter-set-visible-func) :void
  (filter (g-object gtk-tree-model-filter))
  (func :pointer)
  (data :pointer)
  (destroy-notify :pointer))

(defun gtk-tree-model-filter-set-visible-func (tree-model-filter function)
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[func]{A GtkTreeModelFilterVisibleFunc, the visible function.}
  @argument[data]{User data to pass to the visible function, or NULL.}
  @argument[destroy]{Destroy notifier of data, or NULL.}
  @begin{short}
    Sets the visible function used when filtering the filter to be func. The
    function should return TRUE if the given row should be visible and FALSE
    otherwise.
  @end{short}

  If the condition calculated by the function changes over time (e.g. because
  it depends on some global parameters), you must call
  gtk_tree_model_filter_refilter() to keep the visibility information of the
  model uptodate.

  Note that func is called whenever a row is inserted, when it may still be
  empty. The visible function should therefore take special care of empty
  rows, like in the example below.
  @begin{pre}
   static gboolean
   visible_func (GtkTreeModel *model,
                 GtkTreeIter  *iter,
                 gpointer      data)
   {
     /* Visible if row is non-empty and first column is \"HI\" */
     gchar *str;
     gboolean visible = FALSE;

     gtk_tree_model_get (model, iter, 0, &str, -1);
     if (str && strcmp (str, \"HI\") == 0)
       visible = TRUE;
     g_free (str);

     return visible;
   @}
  @end{pre}
  Since 2.4"
  (%gtk-tree-model-filter-set-visible-func
                          tree-model-filter
                          (callback gtk-tree-model-filter-visible-func-callback)
                          (glib::allocate-stable-pointer function)
                          (callback glib::stable-pointer-destroy-notify-cb)))

(export 'gtk-tree-model-filter-set-visible-func)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_set_modify_func ()
;;;
;;; void gtk_tree_model_filter_set_modify_func
;;;                                          (GtkTreeModelFilter *filter,
;;;                                           gint n_columns,
;;;                                           GType *types,
;;;                                           GtkTreeModelFilterModifyFunc func,
;;;                                           gpointer data,
;;;                                           GDestroyNotify destroy);
;;;
;;; With the n_columns and types parameters, you give an array of column types
;;; for this model (which will be exposed to the parent model/view). The func,
;;; data and destroy parameters are for specifying the modify function. The
;;; modify function will get called for each data access, the goal of the modify
;;; function is to return the data which should be displayed at the location
;;; specified using the parameters of the modify function.
;;;
;;; filter :
;;;     A GtkTreeModelFilter.
;;;
;;; n_columns :
;;;     The number of columns in the filter model.
;;;
;;; types :
;;;     The GTypes of the columns.
;;;
;;; func :
;;;     A GtkTreeModelFilterModifyFunc
;;;
;;; data :
;;;     User data to pass to the modify function, or NULL.
;;;
;;; destroy :
;;;     Destroy notifier of data, or NULL.
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_set_visible_column ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_set_visible_column"
          gtk-tree-model-filter-set-visible-column) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[column]{A gint which is the column containing the visible
    information.}
  @begin{short}
    Sets column of the child_model to be the column where filter should look for
    visibility information.
  @end{short}
  columns should be a column of type G_TYPE_BOOLEAN, where TRUE means that a row
  is visible, and FALSE if not.

  Since 2.4"
  (filter (g-object gtk-tree-model-filter))
  (column :int))

(export 'gtk-tree-model-filter-set-visible-column)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_get_model ()
;;;
;;; GtkTreeModel * gtk_tree_model_filter_get_model (GtkTreeModelFilter *filter);
;;;
;;; Returns a pointer to the child model of filter.
;;;
;;; filter :
;;;     A GtkTreeModelFilter.
;;;
;;; Returns :
;;;     A pointer to a GtkTreeModel.
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_convert_child_iter_to_iter ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_convert_child_iter_to_iter"
          %gtk-tree-model-filter-convert-child-iter-to-iter) :boolean
  (filter (g-object gtk-tree-model-filter))
  (filter-iter (g-boxed-foreign gtk-tree-iter))
  (child-iter (g-boxed-foreign gtk-tree-iter)))

(defun gtk-tree-model-filter-convert-child-iter-to-iter (filter iter)
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[filter_iter]{An uninitialized GtkTreeIter.}
  @argument[child_iter]{A valid GtkTreeIter pointing to a row on the child
    model.}
  @begin{return}
    TRUE, if filter_iter was set, i.e. if child_iter is a valid iterator
    pointing to a visible row in child model.
  @end{return}
  @begin{short}
    Sets filter_iter to point to the row in filter that corresponds to the row
    pointed at by child_iter. If filter_iter was not set, FALSE is returned.
  @end{short}

  Since 2.4"
  (let ((filter-iter (make-instance 'gtk-tree-iter)))
    (when (%gtk-tree-model-filter-convert-child-iter-to-iter filter
                                                             filter-iter
                                                             iter)
      filter-iter)))

(export 'gtk-tree-model-filter-convert-child-iter-to-iter)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_convert_iter_to_child_iter ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_convert_iter_to_child_iter" 
          %gtk-tree-model-filter-convert-iter-to-child-iter) :void
  (filter (g-object gtk-tree-model-filter))
  (child-iter (g-boxed-foreign gtk-tree-iter))
  (filter-iter (g-boxed-foreign gtk-tree-iter)))

(defun gtk-tree-model-filter-convert-iter-to-child-iter (filter iter)
 #+cl-cffi-gtk-documentation
 "@version{2013-3-1ß}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[child_iter]{An uninitialized GtkTreeIter.}
  @argument[filter_iter]{A valid GtkTreeIter pointing to a row on filter.}
  @begin{short}
    Sets child_iter to point to the row pointed to by filter_iter.
  @end{short}

  Since 2.4"
  (let ((child-iter (make-instance 'gtk-tree-iter)))
    (%gtk-tree-model-filter-convert-iter-to-child-iter filter child-iter iter)
    child-iter))

(export 'gtk-tree-model-filter-convert-iter-to-child-iter)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_convert_child_path_to_path ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_convert_child_path_to_path"
          gtk-tree-model-filter-convert-child-path-to-path)
    (g-boxed-foreign gtk-tree-path :return)
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[child_path]{A GtkTreePath to convert.}
  @return{A newly allocated GtkTreePath, or NULL.}
  @begin{short}
    Converts child_path to a path relative to filter. That is, child_path points
    to a path in the child model.
  @end{short}
  The returned path will point to the same row in the filtered model. If
  child_path isn't a valid path on the child model or points to a row which is
  not visible in filter, then NULL is returned.

  Since 2.4"
  (filter (g-object gtk-tree-model-sort))
  (child-path (g-boxed-foreign gtk-tree-path)))

(export 'gtk-tree-model-filter-convert-child-path-to-path)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_convert_path_to_child_path ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_convert_path_to_child_path"
          gtk-tree-model-filter-convert-path-to-child-path)
    (g-boxed-foreign gtk-tree-path :return)
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A GtkTreeModelFilter.}
  @argument[filter_path]{A GtkTreePath to convert.}
  @return{A newly allocated GtkTreePath, or NULL.}
  @begin{short}
    Converts filter_path to a path on the child model of filter.
  @end{short}
  That is, filter_path points to a location in filter. The returned path will
  point to the same location in the model not being filtered. If filter_path
  does not point to a location in the child model, NULL is returned.

  Since 2.4"
  (filter (g-object gtk-tree-model-sort))
  (filter-path (g-boxed-foreign gtk-tree-path)))

(export 'gtk-tree-model-filter-convert-path-to-child-path)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_refilter ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_refilter" gtk-tree-model-filter-refilter) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A @class{gtk-tree-model-filter} object.}
  @begin{short}
    Emits the signal \"row_changed\" for each row in the child model, which
    causes the filter to re-evaluate whether a row is visible or not.
  @end{short}

  Since 2.4"
  (filter (g-object gtk-tree-model-filter)))

(export 'gtk-tree-model-filter-refilter)

;;; ----------------------------------------------------------------------------
;;; gtk_tree_model_filter_clear_cache ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_tree_model_filter_clear_cache" gtk-tree-model-filter-clear-cache)
    :void
 #+cl-cffi-gtk-documentation
 "@version{2013-3-10}
  @argument[filter]{A @class{gtk-tree-model-filter} object.}
  @begin{short}
    This function should almost never be called. It clears the filter of any
    cached iterators that haven't been reffed with
    @fun{gtk-tree-model-ref-node}.
  @end{short}

  This might be useful if the child model being filtered is static (and
  doesn't change often) and there has been a lot of unreffed access to nodes.
  As a side effect of this function, all unreffed iters will be invalid.

  Since 2.4"
  (filter (g-object gtk-tree-model-filter)))

(export 'gtk-tree-model-filter-clear-cache)

;;; --- End of file gtk.tree-model-filter.lisp ---------------------------------
