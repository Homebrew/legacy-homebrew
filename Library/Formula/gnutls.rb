require "formula"

# GnuTLS has previous, current, and next stable branches, we use current.
# From 3.4.0 GnuTLS will be permanently disabling SSLv3. Every brew uses will need a revision with that.
# http://nmav.gnutls.org/2014/10/what-about-poodle.html
class Gnutls < Formula
  homepage "http://gnutls.org"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-3.3.9.tar.xz"
  mirror "http://mirrors.dotsrc.org/gcrypt/gnutls/v3.3/gnutls-3.3.9.tar.xz"
  sha256 "39166de5293a9d30ef1cd0a4d97f01fdeed7d7dbf8db95392e309256edcb13c1"

  bottle do
    cellar :any
    sha1 "d040d5a242185d6ecfa9ddafb3e756b484666c5c" => :yosemite
    sha1 "123f5b72837690546cdb2104d9a47b23f905f7b0" => :mavericks
    sha1 "b4fc1dcbc3a7a2407c629671b5ca83cc37262dff" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "guile" => :optional
  depends_on "p11-kit" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Fix libopts Makefile.in, corresponds to upstream commit
  # https://gitorious.org/gnutls/gnutls/commit/db3f46aeca90f6dce42592dd723a15f988264852
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
    ]

    if build.with? "guile"
      args << "--enable-guile"
      args << "--with-guile-site-dir=no"
    end

    system "./configure", *args
    system "make", "install"

    # certtool shadows the OS X certtool utility
    mv bin+"certtool", bin+"gnutls-certtool"
    mv man1+"certtool.1", man1+"gnutls-certtool.1"
  end

  def post_install
    Formula["openssl"].post_install
  end
end

__END__
diff --git a/src/libopts/Makefile.in b/src/libopts/Makefile.in
index 3be797a..8e6d3eb 100644
--- a/src/libopts/Makefile.in
+++ b/src/libopts/Makefile.in
@@ -1546,7 +1546,7 @@ uninstall-am:
 	tags tags-am uninstall uninstall-am
 
 
-+_NORETURN_H=$(srcdir)/compat/_Noreturn.h
+_NORETURN_H=$(srcdir)/compat/_Noreturn.h
 @GL_GENERATE_STDNORETURN_H_TRUE@stdnoreturn.h: stdnoreturn.in.h $(top_builddir)/config.status $(_NORETURN_H)
 @GL_GENERATE_STDNORETURN_H_TRUE@	$(AM_V_GEN)rm -f $@-t $@ && \
 @GL_GENERATE_STDNORETURN_H_TRUE@	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */' && \
