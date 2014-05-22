require 'formula'

class Ffmpeg < Formula
  homepage 'http://ffmpeg.org/'
  url 'http://ffmpeg.org/releases/ffmpeg-2.2.2.tar.bz2'
  sha1 '8a4f282ccb5efbec31a9747d12c8d7b07c481f2e'

  head 'git://git.videolan.org/ffmpeg.git'

  bottle do
    sha1 "3d92cc6e39cb4a931ba0ef6086a3facccc2a4fb6" => :mavericks
    sha1 "abdf840749997229d507bb21096b4950430b2664" => :mountain_lion
    sha1 "65b6fee763e85df649addbe2232e0dec810c7365" => :lion
  end

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"

  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-libvo-aacenc", "Enable VisualOn AAC encoder"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-openjpeg", 'Enable JPEG 2000 image format'
  option 'with-openssl', 'Enable SSL support'
  option 'with-schroedinger', 'Enable Dirac video format'
  option 'with-ffplay', 'Enable FFplay media player'
  option 'with-tools', 'Enable additional FFmpeg tools'
  option 'with-fdk-aac', 'Enable the Fraunhofer FDK AAC library'
  option 'with-libvidstab', 'Enable vid.stab support for video stabilization'
  option 'with-x265', "Enable x265 encoder"

  depends_on 'pkg-config' => :build

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.version >= :mountain_lion
  depends_on 'yasm' => :build

  depends_on 'x264' => :recommended
  depends_on 'faac' => :recommended
  depends_on 'lame' => :recommended
  depends_on 'xvid' => :recommended

  depends_on :freetype => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libvpx' => :optional
  depends_on 'rtmpdump' => :optional
  depends_on 'opencore-amr' => :optional
  depends_on 'libvo-aacenc' => :optional
  depends_on 'libass' => :optional
  depends_on 'openjpeg' => :optional
  depends_on 'sdl' if build.with? "ffplay"
  depends_on 'speex' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'fdk-aac' => :optional
  depends_on 'opus' => :optional
  depends_on 'frei0r' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libbluray' => :optional
  depends_on 'libquvi' => :optional
  depends_on 'libvidstab' => :optional
  depends_on 'x265' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--enable-shared",
            "--enable-pthreads",
            "--enable-gpl",
            "--enable-version3",
            "--enable-nonfree",
            "--enable-hardcoded-tables",
            "--enable-avresample",
            "--enable-vda",
            "--cc=#{ENV.cc}",
            "--host-cflags=#{ENV.cflags}",
            "--host-ldflags=#{ENV.ldflags}"
           ]

    args << "--enable-libx264" if build.with? 'x264'
    args << "--enable-libfaac" if build.with? 'faac'
    args << "--enable-libmp3lame" if build.with? 'lame'
    args << "--enable-libxvid" if build.with? 'xvid'

    args << "--enable-libfreetype" if build.with? 'freetype'
    args << "--enable-libtheora" if build.with? 'theora'
    args << "--enable-libvorbis" if build.with? 'libvorbis'
    args << "--enable-libvpx" if build.with? 'libvpx'
    args << "--enable-librtmp" if build.with? 'rtmpdump'
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? 'opencore-amr'
    args << "--enable-libvo-aacenc" if build.with? 'libvo-aacenc'
    args << "--enable-libass" if build.with? 'libass'
    args << "--enable-ffplay" if build.with? "ffplay"
    args << "--enable-libspeex" if build.with? 'speex'
    args << '--enable-libschroedinger' if build.with? 'schroedinger'
    args << "--enable-libfdk-aac" if build.with? 'fdk-aac'
    args << "--enable-openssl" if build.with? 'openssl'
    args << "--enable-libopus" if build.with? 'opus'
    args << "--enable-frei0r" if build.with? 'frei0r'
    args << "--enable-libcaca" if build.with? 'libcaca'
    args << "--enable-libquvi" if build.with? 'libquvi'
    args << "--enable-libvidstab" if build.with? 'libvidstab'
    args << "--enable-libx265" if build.with? 'x265'

    if build.with? 'openjpeg'
      args << '--enable-libopenjpeg'
      args << '--extra-cflags=' + %x[pkg-config --cflags libopenjpeg].chomp
    end

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace 'config.mak' do |s|
        shflags = s.get_make_var 'SHFLAGS'
        if shflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
          s.change_make_var! 'SHFLAGS', shflags
        end
      end
    end

    system "make install"

    if build.with? "tools"
      system "make alltools"
      bin.install Dir['tools/*'].select {|f| File.executable? f}
    end
  end

end
