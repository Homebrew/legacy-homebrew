require 'formula'

class Gtkdatabox < Formula
  url 'http://netcologne.dl.sourceforge.net/project/gtkdatabox/gtkdatabox/0.9.1.1/gtkdatabox-0.9.1.1.tar.gz'
  homepage 'http://sourceforge.net/projects/gtkdatabox/'
  md5 '910921da2198ebd02ea8a7eb622916ce'

  depends_on 'gtk+'

  def patches
      DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/examples/addremove.c b/examples/addremove.c
--- a/examples/addremove.c
+++ b/examples/addremove.c
@@ -203,7 +203,7 @@
    g_signal_connect_swapped (GTK_OBJECT (close_button), "clicked",
 			     G_CALLBACK (gtk_main_quit), GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
    gtk_widget_show_all (window);
diff --git a/examples/basics.c b/examples/basics.c
--- a/examples/basics.c
+++ b/examples/basics.c
@@ -113,7 +113,7 @@
    g_signal_connect_swapped (GTK_OBJECT (close_button), "clicked",
			     G_CALLBACK (gtk_main_quit), GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (vbox), close_button, FALSE, FALSE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
    gtk_widget_grab_focus (close_button);
 
diff --git a/examples/basics2.c b/examples/basics2.c
--- a/examples/basics2.c
+++ b/examples/basics2.c
@@ -225,7 +225,7 @@
    g_signal_connect_swapped (GTK_OBJECT (close_button), "clicked",
 			     G_CALLBACK (gtk_main_quit), GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (vbox), close_button, FALSE, FALSE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
    gtk_widget_grab_focus (close_button);
 
diff --git a/examples/colors.c b/examples/colors.c
--- a/examples/colors.c
+++ b/examples/colors.c
@@ -194,7 +194,7 @@
    g_signal_connect (G_OBJECT (close_button), "clicked",
 		     G_CALLBACK (gtk_main_quit), (gpointer) NULL);
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
 
diff --git a/examples/enable_disable.c b/examples/enable_disable.c
--- a/examples/enable_disable.c
+++ b/examples/enable_disable.c
@@ -145,7 +145,7 @@
    g_signal_connect_swapped (GTK_OBJECT (close_button), "clicked",
 			     G_CALLBACK (gtk_main_quit), GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    for (i = 0; i < noEnableSets; ++i)
    {
       GtkWidget *vbox = gtk_vbox_new (FALSE, 10);
diff --git a/examples/grid.c b/examples/grid.c
--- a/examples/grid.c
+++ b/examples/grid.c
@@ -133,7 +133,7 @@
 			     G_CALLBACK (gtk_main_quit),
 			     GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
    gtk_widget_show_all (window);
diff --git a/examples/grid_array.c b/examples/grid_array.c
--- a/examples/grid_array.c
+++ b/examples/grid_array.c
@@ -134,7 +134,7 @@
 			     G_CALLBACK (gtk_main_quit),
 			     GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
    gtk_widget_show_all (window);
diff --git a/examples/keycontrol.c b/examples/keycontrol.c
--- a/examples/keycontrol.c
+++ b/examples/keycontrol.c
@@ -133,7 +133,8 @@
    gtk_databox_create_box_with_scrollbars_and_rulers (&box, &table,
 						      TRUE, TRUE, TRUE, TRUE);
    gtk_widget_add_events (box, GDK_KEY_PRESS_MASK);
-   GTK_WIDGET_SET_FLAGS (box, GTK_CAN_FOCUS | GTK_CAN_DEFAULT);
+   gtk_widget_set_can_focus(box, GTK_CAN_FOCUS);
+   gtk_widget_set_can_default(box, GTK_CAN_DEFAULT);
 
    gtk_box_pack_start (GTK_BOX (box1), table, TRUE, TRUE, 0);
 
diff --git a/examples/lissajous.c b/examples/lissajous.c
--- a/examples/lissajous.c
+++ b/examples/lissajous.c
@@ -154,7 +154,7 @@
 			     G_CALLBACK (gtk_main_quit), G_OBJECT (box));
 
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
    lissajous_idle = g_idle_add ((GSourceFunc) lissajous_idle_func, box);
 
diff --git a/examples/logarithmic.c b/examples/logarithmic.c
--- a/examples/logarithmic.c
+++ b/examples/logarithmic.c
@@ -207,7 +207,7 @@
    g_signal_connect (GTK_OBJECT (close_button), "clicked",
 		     G_CALLBACK (gtk_main_quit), NULL);
    gtk_box_pack_start (GTK_BOX (vbox), close_button, FALSE, FALSE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
    gtk_widget_grab_focus (close_button);
 
diff --git a/examples/markers.c b/examples/markers.c
--- a/examples/markers.c
+++ b/examples/markers.c
@@ -220,7 +220,7 @@
    g_signal_connect_swapped (GTK_OBJECT (close_button), "clicked",
 			     G_CALLBACK (gtk_main_quit), GTK_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
    gtk_widget_show_all (window);
diff --git a/examples/signals.c b/examples/signals.c
--- a/examples/signals.c
+++ b/examples/signals.c
@@ -287,7 +287,7 @@
    g_signal_connect_swapped (G_OBJECT (close_button), "clicked",
 			     G_CALLBACK (gtk_main_quit), G_OBJECT (box));
    gtk_box_pack_start (GTK_BOX (box2), close_button, TRUE, TRUE, 0);
-   GTK_WIDGET_SET_FLAGS (close_button, GTK_CAN_DEFAULT);
+   gtk_widget_set_can_default(close_button, GTK_CAN_DEFAULT);
    gtk_widget_grab_default (close_button);
 
    g_signal_connect (G_OBJECT (box), "zoomed",
diff --git a/gtk/gtkdatabox.c b/gtk/gtkdatabox.c
--- a/gtk/gtkdatabox.c
+++ b/gtk/gtkdatabox.c
@@ -453,7 +453,8 @@
       gint width;
       gint height;
 
-      gdk_drawable_get_size (widget->window, &width, &height);
+      width = gdk_window_get_width(widget->window);
+      height = gdk_window_get_height(widget->window);
       x = MAX (0, MIN (width - 1, x));
       y = MAX (0, MIN (height - 1, y));
 
@@ -587,7 +588,7 @@
    gint attributes_mask;
 
    box = GTK_DATABOX (widget);
-   GTK_WIDGET_SET_FLAGS (box, GTK_REALIZED);
+   gtk_widget_set_realized(box, GTK_REALIZED);
 
    attributes.window_type = GDK_WINDOW_CHILD;
    attributes.x = widget->allocation.x;
diff --git a/gtk/gtkdatabox_ruler.c b/gtk/gtkdatabox_ruler.c
--- a/gtk/gtkdatabox_ruler.c
+++ b/gtk/gtkdatabox_ruler.c
@@ -842,7 +842,7 @@
    gint attributes_mask;
 
    ruler = GTK_DATABOX_RULER (widget);
-   GTK_WIDGET_SET_FLAGS (ruler, GTK_REALIZED);
+   gtk_widget_set_realized(ruler, GTK_REALIZED);
 
    attributes.window_type = GDK_WINDOW_CHILD;
    attributes.x = widget->allocation.x;
