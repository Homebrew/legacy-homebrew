require 'formula'

class Mpd < Formula
  homepage 'http://www.musicpd.org/'
  url 'http://www.musicpd.org/download/mpd/0.17/mpd-0.17.4.tar.bz2'
  sha1 'e3a16b5d784c3699b151e72cfa58d0ea54a49b13'

  head 'git://git.musicpd.org/master/mpd.git'

  option 'with-wavpack', 'Build with wavpack support (for .wv files)'
  option 'with-lastfm', 'Build with last-fm support (for experimental Last.fm radio)'
  option 'with-lame', 'Build with lame support (for MP3 encoding when streaming)'
  option 'with-two-lame', 'Build with two-lame support (for MP2 encoding when streaming)'
  option 'with-flac', 'Build with flac support (for Flac encoding when streaming)'
  option 'with-yajl', 'Build with yajl support (for playing from soundcloud)'
  if MacOS.version < :lion
    option 'with-libwrap', 'Build with libwrap (TCP Wrappers) support'
  elsif MacOS.version == :lion
    option 'with-libwrap', 'Build with libwrap (TCP Wrappers) support (buggy)'
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'sqlite'
  depends_on 'libsamplerate'

  depends_on 'ffmpeg'                   # lots of codecs
  # mpd also supports mad, mpg123, libsndfile, and audiofile, but those are
  # redundant with ffmpeg
  depends_on 'fluid-synth'              # MIDI
  depends_on 'faad2'                    # MP4/AAC
  depends_on 'wavpack' => :optional     # WavPack
  depends_on 'libshout' => :optional    # Streaming (also pulls in Vorbis encoding)
  depends_on 'lame' => :optional        # MP3 encoding
  depends_on 'two-lame' => :optional    # MP2 encoding
  depends_on 'flac' => :optional        # Flac encoding
  depends_on 'jack' => :optional        # Output to JACK
  depends_on 'libmms' => :optional      # MMS input
  depends_on 'libzzip' => :optional     # Reading from within ZIPs
  depends_on 'yajl' => :optional        # JSON library for SoundCloud

  def install
    if build.include? 'lastfm' or build.include? 'libwrap' \
       or build.include? 'enable-soundcloud'
      opoo 'You are using an option that has been replaced.'
      opoo 'See this formula\'s caveats for details.'
    end

    if build.with? 'libwrap' and MacOS.version > :lion
      opoo 'Ignoring --with-libwrap: TCP Wrappers were removed in OSX 10.8'
    end

    system './autogen.sh' if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
    ]

    args << '--disable-mad'
    args << '--disable-curl' if MacOS.version <= :leopard

    args << "--with-faad=#{Formula.factory('faad2').opt_prefix}"
    args << '--enable-zzip' if build.with? 'libzzip'
    args << '--enable-lastfm' if build.with? 'lastfm'
    args << '--disable-libwrap' if build.without? 'libwrap'
    args << '--disable-lame-encoder' if build.without? 'lame'
    args << '--disable-soundcloud' if build.without? 'yajl'

    system './configure', *args
    system 'make'
    ENV.j1 # Directories are created in parallel, so let's not do that
    system 'make install'
  end

  def caveats
    <<-EOS
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
