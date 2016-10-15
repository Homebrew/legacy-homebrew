class Thewidgetfactory < Formula
  desc "The Widget Factory is a showcase tool for GTK+ widgets"
  homepage "http://www.stellingwerff.com/?page_id=10"
  url "http://www.stellingwerff.com/TheWidgetFactory/thewidgetfactory-0.2.1.tar.gz"
  sha256 "10bbbe50dc23a0cd47762749c6bb402559721951f3c6af40366258593bcb1ce4"

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  # Avoid warning due to the form being created with an obsolete version of Glade:
  # "GtkSpinButton: setting an adjustment with non-zero page size is deprecated"
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datadir=#{HOMEBREW_PREFIX}/share"
    system "make", "install"
  end

  test do
    # make sure to find all themes, not only those in gtk+'s Cellar
    ENV["GTK_EXE_PREFIX"] = HOMEBREW_PREFIX # gtk_rc_get_module_dir
    ENV["GTK_DATA_PREFIX"] = HOMEBREW_PREFIX # gtk_rc_get_theme_dir
    system "#{bin}/twf"
  end
end

__END__
--- thewidgetfactory-0.2.1/twf.glade.orig	2006-03-29 11:29:47.000000000 +0200
+++ thewidgetfactory-0.2.1/twf.glade	2015-08-15 22:12:47.000000000 +0200
@@ -354,7 +354,7 @@
 		      <property name="update_policy">GTK_UPDATE_ALWAYS</property>
 		      <property name="snap_to_ticks">False</property>
 		      <property name="wrap">False</property>
-		      <property name="adjustment">1 0 100 1 10 10</property>
+		      <property name="adjustment">1 0 100 1 10 0</property>
 		    </widget>
 		    <packing>
 		      <property name="padding">0</property>
@@ -374,7 +374,7 @@
 		      <property name="update_policy">GTK_UPDATE_ALWAYS</property>
 		      <property name="snap_to_ticks">False</property>
 		      <property name="wrap">False</property>
-		      <property name="adjustment">1 0 100 1 10 10</property>
+		      <property name="adjustment">1 0 100 1 10 0</property>
 		    </widget>
 		    <packing>
 		      <property name="padding">0</property>
--- thewidgetfactory-0.2.1/src/interface.c.orig	2006-03-29 11:29:47.000000000 +0200
+++ thewidgetfactory-0.2.1/src/interface.c	2015-08-15 22:37:46.000000000 +0200
@@ -267,12 +267,12 @@ create_window2 (void)
   gtk_widget_show (hbox11);
   gtk_box_pack_start (GTK_BOX (vbox23), hbox11, FALSE, TRUE, 0);
 
-  spinbutton6_adj = gtk_adjustment_new (1, 0, 100, 1, 10, 10);
+  spinbutton6_adj = gtk_adjustment_new (1, 0, 100, 1, 10, 0);
   spinbutton6 = gtk_spin_button_new (GTK_ADJUSTMENT (spinbutton6_adj), 1, 0);
   gtk_widget_show (spinbutton6);
   gtk_box_pack_start (GTK_BOX (hbox11), spinbutton6, FALSE, FALSE, 0);
 
-  spinbutton7_adj = gtk_adjustment_new (1, 0, 100, 1, 10, 10);
+  spinbutton7_adj = gtk_adjustment_new (1, 0, 100, 1, 10, 0);
   spinbutton7 = gtk_spin_button_new (GTK_ADJUSTMENT (spinbutton7_adj), 1, 0);
   gtk_widget_show (spinbutton7);
   gtk_box_pack_start (GTK_BOX (hbox11), spinbutton7, FALSE, FALSE, 0);
