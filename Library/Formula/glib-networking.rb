require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.38/glib-networking-2.38.1.tar.xz'
  sha256 '32ea1e504f69ff6693ac4119ad598ded50bb0440cf4484d28ef0adf8fcc85653'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'
  depends_on 'curl-ca-bundle' => :optional

  def patches
    # Patch to fix installation issue
    # Adapted from upstream: https://git.gnome.org/browse/glib-networking/patch/?id=ce708edb561fa8ea1a5068100f43c6f68092f7f7
    DATA
  end

  def install
    if build.with? "curl-ca-bundle"
      curl_ca_bundle = Formula.factory('curl-ca-bundle').opt_prefix
      certs_options = "--with-ca-certificates=#{curl_ca_bundle}/share/ca-bundle.crt"
    else
      certs_options = "--without-ca-certificates"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          certs_options
    system "make install"
  end
end

__END__
diff --git a/tls/tests/Makefile.in b/tls/tests/Makefile.in
index e657b34..31b96cd 100644
--- a/tls/tests/Makefile.in
+++ b/tls/tests/Makefile.in
@@ -655,7 +655,7 @@ CLEANFILES = *.log *.trs $(am__append_13)
 DISTCLEANFILES = 
 MAINTAINERCLEANFILES = 
 EXTRA_DIST = $(all_dist_test_scripts) $(all_dist_test_data) \
-	$(testfiles_DATA)
+	$(testfiles_data)
 
 # We support a fairly large range of possible variables.  It is expected that all types of files in a test suite
 # will belong in exactly one of the following variables.
@@ -741,8 +741,7 @@ test_programs = certificate file-database connection $(NULL) \
 @HAVE_PKCS11_TRUE@	mock-pkcs11.c mock-pkcs11.h \
 @HAVE_PKCS11_TRUE@	mock-interaction.c mock-interaction.h
 
-testfilesdir = $(installed_testdir)/files
-testfiles_DATA = \
+testfiles_data = \
 	files/ca.pem				\
 	files/ca-roots.pem			\
 	files/ca-verisign-sha1.pem		\
@@ -760,6 +759,8 @@ testfiles_DATA = \
 	files/server-self.pem			\
 	$(NULL)
 
+@ENABLE_INSTALLED_TESTS_TRUE@testfilesdir = $(installed_testdir)/files
+@ENABLE_INSTALLED_TESTS_TRUE@testfiles_DATA = $(testfiles_data)
 all: $(BUILT_SOURCES)
 	$(MAKE) $(AM_MAKEFLAGS) all-am
 
