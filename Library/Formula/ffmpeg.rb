require 'formula'

class Ffmpeg < Formula
  homepage 'http://ffmpeg.org/'
  url 'http://ffmpeg.org/releases/ffmpeg-0.11.1.tar.bz2'
  sha1 'bf01742be60c2e6280371fc4189d5d28933f1a56'

  head 'git://git.videolan.org/ffmpeg.git'

  option "without-x264", "Disable H264 encoder"
  option "without-faac", "Disable AAC encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video format"

  option "with-freetype", "Enable FreeType"
  option "with-theora", "Enable Theora video format"
  option "with-libvorbis", "Enable Vorbis audio format"
  option "with-libogg", "Enable Ogg container format"
  option "with-libvpx", "Enable VP8 video format"
  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-opencore-amr", "Enable AMR audio format"
  option "with-libvo-aacenc", "Enable VisualOn AAC encoder"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-openjpeg", 'Enable JPEG 200 image format'
  option 'with-ffplay', 'Enable FFPlay media player'
  option 'with-tools', 'Enable additional FFmpeg tools'

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.mountain_lion?
  depends_on 'yasm' => :build

  depends_on 'x264' unless build.include? 'without-x264'
  depends_on 'faac' unless build.include? 'without-faac'
  depends_on 'lame' unless build.include? 'without-lame'
  depends_on 'xvid' unless build.include? 'without-xvid'

  depends_on :freetype if build.include? 'with-freetype'
  depends_on 'theora' if build.include? 'with-theora'
  depends_on 'libvorbis' if build.include? 'with-libvorbis'
  depends_on 'libogg' if build.include? 'with-libogg'
  depends_on 'libvpx' if build.include? 'with-libvpx'
  depends_on 'rtmpdump' if build.include? 'with-rtmpdump'
  depends_on 'opencore-amr' if build.include? 'with-opencore-amr'
  depends_on 'libvo-aacenc' if build.include? 'with-libvo-aacenc'
  depends_on 'libass' if build.include? 'with-libass'
  depends_on 'openjpeg' if build.include? 'with-openjpeg'
  depends_on 'sdl' if build.include? 'with-ffplay'

  def install
    args = ["--prefix=#{prefix}",
            "--enable-shared",
            "--enable-gpl",
            "--enable-version3",
            "--enable-nonfree",
            "--enable-hardcoded-tables",
            "--cc=#{ENV.cc}",
            "--host-cflags=#{ENV.cflags}",
            "--host-ldflags=#{ENV.ldflags}"
           ]

    args << "--enable-libx264" unless build.include? 'without-x264'
    args << "--enable-libfaac" unless build.include? 'without-faac'
    args << "--enable-libmp3lame" unless build.include? 'without-lame'
    args << "--enable-libxvid" unless build.include? 'without-xvid'

    args << "--enable-libfreetype" if build.include? 'with-freetype'
    args << "--enable-libtheora" if build.include? 'with-theora'
    args << "--enable-libvorbis" if build.include? 'with-libvorbis'
    args << "--enable-libogg" if build.include? 'with-libogg'
    args << "--enable-libvpx" if build.include? 'with-libvpx'
    args << "--enable-rtmpdump" if build.include? 'with-rtmpdump'
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.include? 'with-opencore-amr'
    args << "--enable-libvo-aacenc" if build.include? 'with-libvo-aacenc'
    args << "--enable-libass" if build.include? 'with-libass'
    args << "--enable-libopenjpeg" if build.include? 'with-openjpeg'
    args << "--enable-ffplay" if build.include? 'with-ffplay'

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.leopard? or Hardware.is_32_bit?

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

    if build.include? 'with-tools'
      system "make alltools"
      bin.install Dir['tools/*'].select {|f| File.executable? f}
    end
  end

end
