require 'formula'

class Mpd < Formula
  homepage "http://www.musicpd.org/"

  stable do
    url "http://www.musicpd.org/download/mpd/0.18/mpd-0.18.11.tar.xz"
    sha1 "34585fcb49107508b198798b5657df07c86157f0"
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

  if MacOS.version < :lion
    option "with-libwrap", "Build with libwrap (TCP Wrappers) support"
  elsif MacOS.version == :lion
    option "with-libwrap", "Build with libwrap (TCP Wrappers) support (buggy)"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "sqlite"
  depends_on "libsamplerate"

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

  depends_on "libvorbis" if build.with? "vorbis" # Vorbis support

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    if build.include? "lastfm" or build.include? "libwrap" \
       or build.include? "enable-soundcloud"
      opoo "You are using an option that has been replaced."
      opoo "See this formula's caveats for details."
    end

    if build.with? "libwrap" and MacOS.version > :lion
      opoo "Ignoring --with-libwrap: TCP Wrappers were removed in OSX 10.8"
    end

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
    ]

    args << "--disable-mad"
    args << "--disable-curl" if MacOS.version <= :leopard

    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.with? "lastfm"
    args << "--disable-libwrap" if build.without? "libwrap"
    args << "--disable-lame-encoder" if build.without? "lame"
    args << "--disable-soundcloud" if build.without? "yajl"
    args << "--enable-vorbis-encoder" if build.with? "vorbis"

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let"s not do that
    system "make install"
  end

  def caveats; <<-EOS.undent
      As of mpd-0.17.4, this formula no longer enables support for streaming
      output by default. If you want streaming output, you must now specify
      the --with-libshout, --with-lame, --with-twolame, and/or --with-flac
      options explicitly. (Use '--with-libshout --with-lame --with-flac' for
      the pre-0.17.4 behavior.)

      As of mpd-0.17.4, this formula has renamed options as follows:
        --lastfm            -> --with-lastfm
        --libwrap           -> --with-libwrap (unsupported in OSX >= 10.8)
        --enable-soundcloud -> --with-yajl
    EOS
  end
end
