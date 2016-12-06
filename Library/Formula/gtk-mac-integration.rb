require 'formula'

class GtkMacIntegration < Formula
  homepage 'https://live.gnome.org/GTK+/OSX'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gtk-mac-integration/2.0/gtk-mac-integration-2.0.1.tar.xz'
  version '2.0.1'
  sha1 '9d939a2e4fb6c0ab4fe3d544ac712a152451249a'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'

  def patches
    # link integration test with Cocoa framework
    # make it compile with clang
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"

    prefix.install "src/.libs/test-integration"
    (prefix + "src").install "src/testui.xml"
  end

  def test
    cd prefix do
      system "./test-integration"
    end
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index 097eedd..ea7ead0 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -325,7 +325,7 @@ integration_include_HEADERS = \
 
 test_integration_SOURCES = test-integration.c
 test_integration_CFLAGS = $(MAC_CFLAGS)
-test_integration_LDADD = $(MAC_LIBS) libgtkmacintegration.la
+test_integration_LDADD = $(MAC_LIBS) -framework Cocoa libgtkmacintegration.la
 EXTRA_DIST = testui.xml
 @HAVE_INTROSPECTION_TRUE@@INTROSPECTION_TRUE@GtkosxApplication_1_0_gir_SCANNERFLAGS = \
 @HAVE_INTROSPECTION_TRUE@@INTROSPECTION_TRUE@	--identifier-prefix=Gtkosx \
diff --git a/src/cocoa_menu_item.c b/src/cocoa_menu_item.c
index f089569..48c6793 100644
--- a/src/cocoa_menu_item.c
+++ b/src/cocoa_menu_item.c
@@ -524,7 +524,7 @@ cocoa_menu_item_add_item (NSMenu* cocoa_menu, GtkWidget* menu_item, int index)
     DEBUG ("\ta separator\n");
   } else {
     const gchar* text = get_menu_label_text (menu_item, &label);
-    NSString *title = [NSString stringWithUTF8String:(text ? text : @"")];
+    NSString *title = [NSString stringWithUTF8String:(text ? text : "")];
 
     GClosure *menu_action =
       g_cclosure_new_object_swap(G_CALLBACK(gtk_menu_item_activate),
