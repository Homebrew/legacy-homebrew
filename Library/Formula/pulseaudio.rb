require 'formula'

class Pulseaudio < Formula
  homepage 'http://pulseaudio.org'
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-4.0.tar.xz'
  sha1 '9f0769dcb25318ba3faaa453fd2ed0c509fa9c5c'

  option 'with-nls', 'Build with native language support'
  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'libtool' => :build
  depends_on 'intltool' => :build if build.with? 'nls'
  depends_on 'gettext' => :build if build.with? 'nls'

  depends_on 'json-c'
  depends_on 'libsndfile'
  depends_on 'libsamplerate'
  depends_on 'libiconv'

  depends_on :x11 => :optional
  depends_on 'glib' => :optional
  depends_on 'gconf' => :optional
  depends_on 'dbus' => :optional
  depends_on 'gtk+3' => :optional
  depends_on 'jack' => :optional

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def patches
    # Patch configuration files to automatically load CoreAudio modules instead of udev/static hardware detection
    # https://bugs.freedesktop.org/show_bug.cgi?id=55154
    #DATA
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-coreaudio-output
      --with-mac-sysroot=/
      --prefix=#{prefix}
    ]
    args << '--with-mac-sysroot=' + MacOS.sdk_path
    args << '--with-mac-version-min=' + MacOS.version
    args << '--disable-nls' unless build.with? 'nls'
    if build.universal? 
      args << '--enable-mac-universal' 
      ENV.universal_binary
    end
    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/daemon/default.pa.in b/src/daemon/default.pa.in
index f50d929..cbfdb42 100755
--- a/src/daemon/default.pa.in
+++ b/src/daemon/default.pa.in
@@ -67,15 +67,8 @@ ifelse(@HAVE_MKFIFO@, 1, [dnl
 ])dnl
 
 ### Automatically load driver modules depending on the hardware available
-ifelse(@HAVE_UDEV@, 1, [dnl
-.ifexists module-udev-detect@PA_SOEXT@
-load-module module-udev-detect
-.else
-], [dnl
-.ifexists module-detect@PA_SOEXT@
-])dnl
-### Use the static hardware detection module (for systems that lack udev support)
-load-module module-detect
+.ifexists module-coreaudio-detect@PA_SOEXT@
+load-module module-coreaudio-detect
 .endif
 
 ### Automatically connect sink and source if JACK server is present

diff --git a/src/daemon/system.pa.in b/src/daemon/system.pa.in
index e881a12..e9fb1a5 100755
--- a/src/daemon/system.pa.in
+++ b/src/daemon/system.pa.in
@@ -21,19 +21,8 @@
 changequote(`[', `]')dnl Set up m4 quoting
 
 ### Automatically load driver modules depending on the hardware available
-ifelse(@HAVE_UDEV@, 1, [dnl
-.ifexists module-udev-detect@PA_SOEXT@
-load-module module-udev-detect
-.else
-], @HAVE_HAL@, 1, [dnl
-.ifexists module-hal-detect@PA_SOEXT@
-load-module module-hal-detect
-.else
-], [dnl
-.ifexists module-detect@PA_SOEXT@
-])dnl
-### Use the static hardware detection module (for systems that lack udev/hal support)
-load-module module-detect
+.ifexists module-coreaudio-detect@PA_SOEXT@
+load-module module-coreaudio-detect
 .endif
 
 ### Load several protocols
