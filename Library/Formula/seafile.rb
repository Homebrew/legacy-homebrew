class Seafile < Formula
  desc "A daemon program used in seafile-client"
  homepage "http://www.seafile.com/"
  url "https://github.com/haiwen/seafile/archive/v4.2.8.tar.gz"
  sha256 "d9e3ed479fdc997df1b767133a065f2ceaa5a5a5f51184fe5964d01abc7c8cb2"

  head "https://github.com/haiwen/seafile.git"

  # FIX for homebrew autotools path
  # FIX use system zlib
  patch :DATA

  # [FIX] fix openssl build
  patch :p1 do
    url "https://github.com/Chilledheart/seafile/commit/79fc942d.diff"
    sha1 "a4c81dbf6e131502b2c229b9cab2f324e8c51e5d"
  end

  depends_on MinimumMacOSRequirement => :snow_leopard

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "jansson"
  depends_on "libevent"
  depends_on "openssl"

  depends_on "libsearpc"
  depends_on "ccnet"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-client
      --disable-server
      --disable-fuse
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir_p testpath/"conf"
    mkdir_p testpath/"data"
    (testpath/"conf/ccnet.conf").write <<-EOS.undent
      [General]
      USER_NAME = test
      ID = fa69e633a6bb4b08c27727d53db0450295258e52
      NAME = test@test.com

      [Network]
      PORT = 10001

      [Client]
      PORT = 13419
    EOS
    ENV["PYTHONPATH"] = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
    system "#{bin}/seaf-cli", "init", "-c", testpath/"conf", "-d", testpath/"data"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index ec1d2c2..2390b65 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -98,7 +98,7 @@ aclocalinclude="$aclocalinclude -I m4"
 if test x"$MSYSTEM" = x"MINGW32"; then
     aclocalinclude="$aclocalinclude -I /local/share/aclocal"
 elif test "$(uname)" = "Darwin"; then
-    aclocalinclude="$aclocalinclude -I /opt/local/share/aclocal"
+    aclocalinclude="$aclocalinclude -I /usr/local/share/aclocal"
 fi


diff --git a/configure.ac b/configure.ac
index ccb356d..9ab3ffa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -156,6 +156,8 @@ if test "$bwin32" != true; then
   if test "$bmac" = true; then
   AC_CHECK_LIB(c, uuid_generate, [echo "found library uuid"],
           AC_MSG_ERROR([*** Unable to find uuid_generate in libc]), )
+  AC_CHECK_LIB(z, inflate, [echo "found library zlib"],
+          AC_MSG_ERROR([*** Unable to find inflate in zlib]), )
   else
   AC_CHECK_LIB(uuid, uuid_generate, [echo "found library uuid"],
           AC_MSG_ERROR([*** Unable to find uuid library]), )
@@ -270,7 +272,12 @@ PKG_CHECK_MODULES(LIBEVENT, [libevent >= $LIBEVENT_REQUIRED])
 AC_SUBST(LIBEVENT_CFLAGS)
 AC_SUBST(LIBEVENT_LIBS)
 
-PKG_CHECK_MODULES(ZLIB, [zlib >= $ZLIB_REQUIRED])
+if test "$bmac" = true; then
+  ZLIB_CFLAGS=
+  ZLIB_LIBS=-lz
+else
+  PKG_CHECK_MODULES(ZLIB, [zlib >= $ZLIB_REQUIRED])
+fi
 AC_SUBST(ZLIB_CFLAGS)
 AC_SUBST(ZLIB_LIBS)
 
