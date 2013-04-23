require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://www.musicpd.org/download/mpd/0.17/mpd-0.17.4.tar.bz2'
  sha1 'e3a16b5d784c3699b151e72cfa58d0ea54a49b13'

  head "git://git.musicpd.org/master/mpd.git"


  #
  # Options.
  # Many of these correspond to :optional dependencies below (and are included
  # to give those options more informative descriptions.) Such options are
  # listed in the same section and order as below.
  #

  # Input
  option 'with-wavpack', "Build with support for WavPack (.wv) files"
  option "enable-lastfm", "Compile with experimental support for Last.fm radio"

  # Streaming output encoding
  option 'with-lame', "Build with lame support (for mp3 encoding when streaming)"
  option 'with-two-lame', "Build with TwoLAME support (for mp2 encoding when streaming)"
  option 'with-flac', "Build with flac support (for flac encoding when streaming)"

  # Misc.
  option 'with-yajl', "Build with yajl support (for playing from soundcloud)"
  if MacOS.version < :lion
    option "with-libwrap", "Build with libwrap (TCP Wrappers) support"
  elsif MacOS.version == :lion
    option "with-libwrap", "Build with libwrap (TCP Wrappers) support (buggy!)"
  end


  #
  # Dependencies.
  # Note that while :optional dependencies generate an option automatically,
  # some are specified explicitly above to give them more informative
  # descriptions.
  #

  # Basic dependencies
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'sqlite'
  depends_on 'libsamplerate'

  # Input decoding
  depends_on 'ffmpeg'                   # lots
  depends_on 'fluid-synth'              # MIDI
  depends_on 'faad2'                    # MP4/AAC
  depends_on 'wavpack' => :optional     # WavPack
  # mpd also supports mad, mpg123, libsndfile, and audiofile, but those are
  # redundant with ffmpeg

  # Streaming output encoding
  depends_on 'libshout' => :optional    # N. B. pulls in Vorbis encoder
  depends_on 'lame' => :optional        # mp3 encoding
  depends_on 'two-lame' => :optional    # mp2 encoding
  depends_on 'flac' => :optional        # flac encoding

  # Misc.
  depends_on 'jack' => :optional        # Output to JACK
  depends_on 'libmms' => :optional      # MMS input
  depends_on 'libzzip' => :optional     # reading from within ZIPs
  depends_on 'yajl' => :optional        # JSON library for soundcloud


  #
  # Build rules.
  #

  def install
    options_check

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
    ]

    # Disable buggy or experimental things
    args << "--disable-curl" if MacOS.version == :leopard

    # Things ./configure defaults to off that we might want turned on
    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.include? "enable-lastfm"
    args << "--with-faad=#{Formula.factory("faad2").opt_prefix}"

    # Things ./configure defaults to on that we might want turned off
    args << "--disable-libwrap" unless build.with? 'libwrap'
    # It finds these in some circumstances even if we don't want it to. If that
    # happens, we'll build/link against them, which isn't the end of the world,
    # but it's easy to prevent:
    args << "--disable-mad"
    args << "--disable-lame-encoder" unless build.with?("lame")
    # YAJL is similar, except if ./configure autodetects it, the build will
    # actually fail!
    args << "--disable-soundcloud" unless build.with?("yajl")

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let's not do that
    system "make install"
  end


  #
  # Checks and messages.
  #

  def options_check
    if build.include? 'lastfm' or build.include? 'libwrap' or build.include? 'enable-soundcloud'
      opoo "You are using an option that has been replaced."
      opoo "See this brew's caveats for details."
    end
    if build.include? 'with-libwrap' and MacOS.version > :lion
      opoo "Ignoring --with-libwrap: TCP Wrappers was removed in OSX 10.8"
    end
  end

  def caveats
    <<-EOS
      As of mpd-0.17.4, this brew no longer enables support for streaming
      output by default. If you want streaming output, you must now specify
      the --with-libshout, --with-lame, --with-twolame, and/or --with-flac
      options explicitly. (Use "--with-libshout --with-lame --with-flac" for
      the pre-0.17.4 behavior.)


      As of mpd-0.17.4, this brew has renamed options as follows:

        Old name                   New name
        ===================        ===============
        --lastfm              ->   --enable-lastfm
        --libwrap             ->   --with-libwrap   (unsupported in OSX >= 10.8)
        --enable-soundcloud   ->   --with-yajl

      If you use lastfm, libwrap, or soundcloud, please adjust your options
      accordingly.
    EOS
  end
end
