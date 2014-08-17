require 'formula'

class Neon < Formula
  homepage 'http://www.webdav.org/neon/'
  url 'http://www.webdav.org/neon/neon-0.30.0.tar.gz'
  sha1 '9e6297945226f90d66258b7ee05f757ff5cea10a'

  bottle do
    cellar :any
    sha1 "9e4015e3e27d14ddd8feb4bdc1dc84a01a930bea" => :mavericks
    sha1 "cb912fbe59f2c4b1b8139989ff9d7ffc1b2210d4" => :mountain_lion
    sha1 "4d67105dc74e5f4f6f58c542a741cb532257b393" => :lion
  end

  keg_only :provided_by_osx

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'openssl'

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.enable_warnings
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl"].opt_prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index b0a7908..a0f2ceb 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }
 
 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
