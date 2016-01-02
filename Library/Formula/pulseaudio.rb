class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "http://pulseaudio.org"
  url "http://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-6.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pulseaudio/pulseaudio_6.0.orig.tar.xz"
  sha256 "b50640e0b80b1607600accfad2e45aabb79d379bf6354c9671efa2065477f6f6"

  bottle do
    sha256 "d57bc83ad5fc738faeb8fe64b03139e1164cecff7cc969b17f4b551e31ff25fa" => :yosemite
    sha256 "5e7826508922b199bf1027e4961c3a747a97b2f73496993bae3c3453f53fa442" => :mavericks
    sha256 "1f2204be6e1ecd20380a6593dd4e49608e1d7be42caf60d29c43ec1587dae97e" => :mountain_lion
  end

  head do
    url "http://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"
  option :universal

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsamplerate"
  depends_on "openssl"

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "d-bus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  # i386 patch per MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/15fa4f03/pulseaudio/i386.patch"
    sha256 "d3a2180600a4fbea538949b6c4e9e70fe7997495663334e50db96d18bfb1da5f"
  end

  # Fix CoreServices header location check in configure for Xcode-only
  # https://bugs.freedesktop.org/show_bug.cgi?id=55152
  patch :DATA

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --with-mac-sysroot=/
    ]

    args << "--with-mac-sysroot=#{MacOS.sdk_path}"
    args << "--with-mac-version-min=#{MacOS.version}"
    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end

__END__
diff --git a/configure b/configure
index a3c0fa4..39a7da8 100755
--- a/configure
+++ b/configure
@@ -22314,29 +22314,14 @@ fi
 if test "x$os_is_darwin" = "x1" ; then
     { $as_echo "$as_me:${as_lineno-$LINENO}: checking looking for Apple CoreService Framework" >&5
 $as_echo_n "checking looking for Apple CoreService Framework... " >&6; }
-    # How do I check a framework "library" - AC_CHECK_LIB prob. won't work??, just assign LIBS & hope
-    ac_fn_c_check_header_mongrel "$LINENO" "/Developer/Headers/FlatCarbon/CoreServices.h" "ac_cv_header__Developer_Headers_FlatCarbon_CoreServices_h" "$ac_includes_default"
-if test "x$ac_cv_header__Developer_Headers_FlatCarbon_CoreServices_h" = xyes; then :
+    ac_fn_c_check_header_mongrel "$LINENO" "CoreServices/CoreServices.h" "ac_cv_header_CoreServices_CoreServices_h" "$ac_includes_default"
+if test "x$ac_cv_header_CoreServices_CoreServices_h" = xyes; then :
   LIBS="$LIBS -framework CoreServices"
 else
-  for ac_header in /System/Library/Frameworks/CoreServices.framework/Headers/CoreServices.h
-do :
-  ac_fn_c_check_header_mongrel "$LINENO" "/System/Library/Frameworks/CoreServices.framework/Headers/CoreServices.h" "ac_cv_header__System_Library_Frameworks_CoreServices_framework_Headers_CoreServices_h" "$ac_includes_default"
-if test "x$ac_cv_header__System_Library_Frameworks_CoreServices_framework_Headers_CoreServices_h" = xyes; then :
-  cat >>confdefs.h <<_ACEOF
-#define HAVE__SYSTEM_LIBRARY_FRAMEWORKS_CORESERVICES_FRAMEWORK_HEADERS_CORESERVICES_H 1
-_ACEOF
- LIBS="$LIBS -framework CoreServices"
-else
   as_fn_error $? "CoreServices.h header file not found" "$LINENO" 5

 fi

-done
-
-
-fi
-


     { $as_echo "$as_me:${as_lineno-$LINENO}: result: ok" >&5
