require 'formula'

class Mpd < Formula
  homepage "http://www.musicpd.org/"
  url "http://www.musicpd.org/download/mpd/0.19/mpd-0.19.1.tar.xz"
  sha1 "68f1ff43a2dd4de913d6c979db504dc2955f5737"
  revision 1

  bottle do
    sha1 "5ae7e75ccb454ec5bb7ac78266346168132ead1e" => :yosemite
    sha1 "917c7d262cb096cbb7ee81a66558ccba79b99c80" => :mavericks
    sha1 "88426fd9b9264fcfe2c5f31298e1844105e7850c" => :mountain_lion
  end

  head do
    url "git://git.musicpd.org/master/mpd.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-wavpack", "Build with wavpack support (for .wv files)"
  option "with-lastfm", "Build with last-fm support (for experimental Last.fm radio)"
  option "with-lame", "Build with lame support (for MP3 encoding when streaming)"
  option "with-two-lame", "Build with two-lame support (for MP2 encoding when streaming)"
  option "with-flac", "Build with flac support (for Flac encoding when streaming)"
  option "with-vorbis", "Build with vorbis support (for Ogg encoding)"
  option "with-yajl", "Build with yajl support (for playing from soundcloud)"
  option "with-opus", "Build with opus support (for Opus encoding and decoding)"

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "sqlite"
  depends_on "libsamplerate"
  depends_on "icu4c"

  needs :cxx11

  depends_on "libmpdclient"
  depends_on "ffmpeg"                   # lots of codecs
  # mpd also supports mad, mpg123, libsndfile, and audiofile, but those are
  # redundant with ffmpeg
  depends_on "fluid-synth"              # MIDI
  depends_on "faad2"                    # MP4/AAC
  depends_on "wavpack" => :optional     # WavPack
  depends_on "libshout" => :optional    # Streaming (also pulls in Vorbis encoding)
  depends_on "lame" => :optional        # MP3 encoding
  depends_on "two-lame" => :optional    # MP2 encoding
  depends_on "flac" => :optional        # Flac encoding
  depends_on "jack" => :optional        # Output to JACK
  depends_on "libmms" => :optional      # MMS input
  depends_on "libzzip" => :optional     # Reading from within ZIPs
  depends_on "yajl" => :optional        # JSON library for SoundCloud
  depends_on "opus" => :optional        # Opus support

  depends_on "libvorbis" if build.with? "vorbis" # Vorbis support

  # Fix mpd in daemon mode
  # See http://bugs.musicpd.org/view.php?id=4141 for more details
  patch :DATA

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
      --disable-libwrap
    ]

    args << "--disable-mad"
    args << "--disable-curl" if MacOS.version <= :leopard

    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.with? "lastfm"
    args << "--disable-lame-encoder" if build.without? "lame"
    args << "--disable-soundcloud" if build.without? "yajl"
    args << "--enable-vorbis-encoder" if build.with? "vorbis"

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let"s not do that
    system "make install"
  end

  plist_options :manual => "mpd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpd</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
    </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/src/Main.cxx b/src/Main.cxx
index d17590e..9457f86 100644
--- a/src/Main.cxx
+++ b/src/Main.cxx
@@ -114,6 +114,10 @@
 #include <ws2tcpip.h>
 #endif
 
+#ifdef __APPLE__
+#include <dispatch/dispatch.h>
+#endif
+
 #include <limits.h>
 
 static constexpr unsigned DEFAULT_BUFFER_SIZE = 4096;
@@ -401,8 +405,6 @@ int main(int argc, char *argv[])
 {
 #ifdef WIN32
 	return win32_main(argc, argv);
-#elif __APPLE__
-	return osx_main(argc, argv);
 #else
 	return mpd_main(argc, argv);
 #endif
@@ -410,6 +412,8 @@ int main(int argc, char *argv[])
 
 #endif
 
+static int mpd_main_after_fork(struct options);
+
 #ifdef ANDROID
 static inline
 #endif
@@ -513,6 +517,33 @@ int mpd_main(int argc, char *argv[])
 	daemonize_begin(options.daemon);
 #endif
 
+#ifdef __APPLE__
+	/*
+	 * Run the OS X native event loop in the main thread, and the rest of
+	 * mpd_main on a new thread. This lets CoreAudio receive route change
+	 * notifications (e.g. plugging or unplugging headphones). All hardware
+	 * output on OS X ultimately uses CoreAudio internally. This must be
+	 * run after forking; if dispatch is called before forking, the child
+	 * process will have a broken internal dispatch state.
+	 */
+	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
+		exit(mpd_main_after_fork(options));
+	});
+	dispatch_main();
+	/*
+	 * This point is unreachable as dispatch_main never returns, so calm
+	 * down compiler.
+	 */
+	return EXIT_FAILURE;
+#else
+	return mpd_main_after_fork(options);
+#endif
+}
+
+static int mpd_main_after_fork(struct options options)
+{
+	Error error;
+
 	GlobalEvents::Initialize(*instance->event_loop);
 	GlobalEvents::Register(GlobalEvents::IDLE, idle_event_emitted);
 #ifdef WIN32
