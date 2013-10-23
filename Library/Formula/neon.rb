require 'formula'

class Neon < Formula
  homepage 'http://www.webdav.org/neon/'
  url 'http://www.webdav.org/neon/neon-0.30.0.tar.gz'
  sha1 '9e6297945226f90d66258b7ee05f757ff5cea10a'

  keg_only :provided_by_osx,
            "Compiling newer versions of Subversion on 10.6 require this newer neon."

  option :universal
  option 'with-brewed-openssl', 'Include OpenSSL support via Homebrew'

  depends_on 'pkg-config' => :build
  depends_on 'openssl' if build.with? 'brewed-openssl'

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  def patches; DATA; end

  def install
    ENV.universal_binary if build.universal?
    ENV.enable_warnings
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-shared",
      "--disable-static",
      "--disable-nls",
      "--with-ssl",
    ]
    if build.with? 'brewed-openssl'
      args << "--with-libs=" + Formula.factory('openssl').opt_prefix.to_s
    end
    system "./configure", *args
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
