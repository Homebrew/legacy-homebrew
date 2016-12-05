class LibvirtGlib < Formula
  desc "GLib and GObject mapping for libvirt"
  homepage "http://www.libvirt.org"
  url "http://libvirt.org/sources/glib/libvirt-glib-0.2.3.tar.gz"
  sha256 "c3b11aa34584b3416148b36bb005505e461830c73c9fd2f40143cca3309250dd"

  depends_on "gettext" => :build
  depends_on "glib"
  depends_on "intltool" => :build
  depends_on "libvirt"
  depends_on "pkg-config" => :build

  depends_on "gobject-introspection" => :optional
  depends_on "vala" => :optional

  # work around ld not understanding --version-script argument
  # upstream bug: https://bugzilla.redhat.com/show_bug.cgi?id=1304981
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --enable-installed-tests
      --enable-always-build-tests
      --with-python
    ]

    args << "--enable-vala" if build.with? "vala"
    args << "--enable-introspection" if build.with? "gobject-introspection"

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    system "#{libexec}/installed-tests/libvirt-glib/test-gconfig"
  end
end

__END__
diff --git a/libvirt-gconfig/Makefile.in b/libvirt-gconfig/Makefile.in
index 42e4352..d851d96 100644
--- a/libvirt-gconfig/Makefile.in
+++ b/libvirt-gconfig/Makefile.in
@@ -747,7 +747,6 @@ libvirt_gconfig_1_0_la_DEPENDENCIES = \
 libvirt_gconfig_1_0_la_LDFLAGS = \
 			$(COVERAGE_CFLAGS:-f%=-Wc,f%) \
 			$(CYGWIN_EXTRA_LDFLAGS) $(MINGW_EXTRA_LDFLAGS) \
-			-Wl,--version-script=$(srcdir)/libvirt-gconfig.sym \
 			-version-info $(LIBVIRT_GLIB_VERSION_INFO)
 
 BUILT_SOURCES = $(GCONFIG_GENERATED_FILES)
diff --git a/libvirt-glib/Makefile.in b/libvirt-glib/Makefile.in
index 3523684..a370ae8 100644
--- a/libvirt-glib/Makefile.in
+++ b/libvirt-glib/Makefile.in
@@ -436,7 +436,6 @@ libvirt_glib_1_0_la_DEPENDENCIES = \
 libvirt_glib_1_0_la_LDFLAGS = \
 			$(COVERAGE_CFLAGS:-f%=-Wc,f%) \
 			$(CYGWIN_EXTRA_LDFLAGS) $(MINGW_EXTRA_LDFLAGS) \
-			-Wl,--version-script=$(srcdir)/libvirt-glib.sym \
 			-version-info $(LIBVIRT_GLIB_VERSION_INFO)
 
 INTROSPECTION_GIRS = $(am__append_1)
diff --git a/libvirt-gobject/Makefile.in b/libvirt-gobject/Makefile.in
index 26e0df6..fb02f78 100644
--- a/libvirt-gobject/Makefile.in
+++ b/libvirt-gobject/Makefile.in
@@ -520,7 +520,6 @@ libvirt_gobject_1_0_la_DEPENDENCIES = \
 libvirt_gobject_1_0_la_LDFLAGS = \
 			$(COVERAGE_CFLAGS:-f%=-Wc,f%) \
 			$(CYGWIN_EXTRA_LDFLAGS) $(MINGW_EXTRA_LDFLAGS) \
-			-Wl,--version-script=$(srcdir)/libvirt-gobject.sym \
 			-version-info $(LIBVIRT_GLIB_VERSION_INFO)
 
 BUILT_SOURCES = $(GOBJECT_GENERATED_FILES)
diff --git a/tests/Makefile.in b/tests/Makefile.in
--- a/tests/Makefile.in	2016-02-05 16:44:14.000000000 +0800
+++ b/tests/Makefile.in	2016-02-05 16:47:47.000000000 +0800
@@ -704,6 +704,21 @@
 @ENABLE_TESTS_TRUE@	$(GOBJECT2_LIBS)
 
 @ENABLE_TESTS_TRUE@test_programs = test-gconfig test-events
+@ENABLE_TESTS_TRUE@test_data = xml/gconfig-domain-clock.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-cpu.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-channel.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-console.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-disk.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-filesys.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-graphics.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-input.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-network.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-sound.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-usbredir.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-device-video.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain-os.xml \
+@ENABLE_TESTS_TRUE@	xml/gconfig-domain.xml
+
 all: $(BUILT_SOURCES)
 	$(MAKE) $(AM_MAKEFLAGS) all-am
 
