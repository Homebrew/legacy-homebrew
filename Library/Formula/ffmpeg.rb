require 'formula'

class Ffmpeg < Formula
  homepage 'http://ffmpeg.org/'
  url 'http://ffmpeg.org/releases/ffmpeg-0.11.1.tar.bz2'
  sha1 'bf01742be60c2e6280371fc4189d5d28933f1a56'

  head 'git://git.videolan.org/ffmpeg.git'

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.mountain_lion?
  depends_on 'yasm' => :build
  depends_on :x11
  depends_on 'x264' => :optional
  depends_on 'faac' => :optional
  depends_on 'lame' => :optional
  depends_on 'rtmpdump' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvpx' => :optional
  depends_on 'xvid' => :optional
  depends_on 'opencore-amr' => :optional
  depends_on 'libvo-aacenc' => :optional
  depends_on 'libass' => :optional

  depends_on 'sdl' if build.include? 'with-ffplay'
  depends_on 'openjpeg' if build.include? 'with-openjpeg'

  option 'with-tools', 'Install additional FFmpeg tools'
  option 'with-ffplay', 'Build ffplay'
  option 'with-openjpeg', 'Use openjpeg for jpeg2000 support'

  def install
    args = ["--prefix=#{prefix}",
            "--enable-shared",
            "--enable-gpl",
            "--enable-version3",
            "--enable-nonfree",
            "--enable-hardcoded-tables",
            "--enable-libfreetype",
            "--cc=#{ENV.cc}",
            "--host-cflags=#{ENV.cflags}",
            "--host-ldflags=#{ENV.ldflags}"
           ]

    args << "--enable-libx264" if Formula.factory('x264').linked_keg.exist?
    args << "--enable-libfaac" if Formula.factory('faac').linked_keg.exist?
    args << "--enable-libmp3lame" if Formula.factory('lame').linked_keg.exist?
    args << "--enable-librtmp" if Formula.factory('rtmpdump').linked_keg.exist?
    args << "--enable-libtheora" if Formula.factory('theora').linked_keg.exist?
    args << "--enable-libvorbis" if Formula.factory('libvorbis').linked_keg.exist?
    args << "--enable-libvpx" if Formula.factory('libvpx').linked_keg.exist?
    args << "--enable-libxvid" if Formula.factory('xvid').linked_keg.exist?
    args << "--enable-libopencore-amrnb" if Formula.factory('opencore-amr').linked_keg.exist?
    args << "--enable-libopencore-amrwb" if Formula.factory('opencore-amr').linked_keg.exist?
    args << "--enable-libass" if Formula.factory('libass').linked_keg.exist?
    args << "--enable-libvo-aacenc" if Formula.factory('libvo-aacenc').linked_keg.exist?
    args << "--disable-ffplay" unless build.include? 'with-ffplay'
    args << "--enable-libopenjpeg" if build.include? 'with-openjpeg'

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    if MacOS.leopard? or Hardware.is_32_bit?
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

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
