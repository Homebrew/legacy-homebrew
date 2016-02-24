class Mpd < Formula
  desc "Music Player Daemon"
  homepage "http://www.musicpd.org/"
  url "http://www.musicpd.org/download/mpd/0.19/mpd-0.19.13.tar.xz"
  sha256 "f1014838fa7ab2d5fe2ef7f4c101d58fdec2c4c13cfbd2462ee146c8e4919a55"

  bottle do
    cellar :any
    sha256 "519db64468e6d743e37cc7d312dfd9313bf1cbd0b18c12d99cf18b38ef3c4dc0" => :el_capitan
    sha256 "87bda8fa0657f2faf637243b965769446d3318e023c2ca3e50f6f07f7cbf35e3" => :yosemite
    sha256 "84616412b8473feb5bec4925a976c730a478a364239fd786e088d94970a12964" => :mavericks
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
  option "with-libvorbis", "Build with vorbis support (for Ogg encoding)"
  option "with-yajl", "Build with yajl support (for playing from soundcloud)"
  option "with-opus", "Build with opus support (for Opus encoding and decoding)"

  deprecated_option "with-vorbis" => "with-libvorbis"

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "sqlite"
  depends_on "libsamplerate"
  depends_on "icu4c"

  needs :cxx11

  depends_on "libmpdclient"
  depends_on "ffmpeg" # lots of codecs
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
  depends_on "libvorbis" => :optional
  depends_on "libnfs" => :optional
  depends_on "mad" => :optional

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
      --sysconfdir=#{etc}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
      --disable-libwrap
    ]

    args << "--disable-mad" if build.without? "mad"
    args << "--disable-curl" if MacOS.version <= :leopard

    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.with? "lastfm"
    args << "--disable-lame-encoder" if build.without? "lame"
    args << "--disable-soundcloud" if build.without? "yajl"
    args << "--enable-vorbis-encoder" if build.with? "libvorbis"
    args << "--enable-nfs" if build.with? "libnfs"

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let's not do that
    system "make", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
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

  test do
    pid = fork do
      exec "#{bin}/mpd --stdout --no-daemon --no-config"
    end
    sleep 2

    begin
      assert_match "OK MPD", shell_output("curl localhost:6600")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
