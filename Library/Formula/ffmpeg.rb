class Ffmpeg < Formula
  homepage "https://ffmpeg.org/"
  url "https://www.ffmpeg.org/releases/ffmpeg-2.5.2.tar.bz2"
  sha1 "e167475426e8edf55601e79d3367c2210baa5f11"

  head "git://git.videolan.org/ffmpeg.git"

  bottle do
    sha1 "5d5b37346fd3b87bbd48e6acd4e640f5cfdf1f16" => :yosemite
    sha1 "b2c1ce59ee31569d33c72357bb19328769974d30" => :mavericks
    sha1 "1732376b6c4e09a8ea9be11f1ec5d261970af760" => :mountain_lion
  end

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"
  option "without-qtkit", "Disable deprecated QuickTime framework"

  option "with-rtmpdump", "Enable RTMP protocol"
  option "without-libvo-aacenc", "Enable VisualOn AAC encoder"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-ffplay", "Enable FFplay media player"
  option "with-tools", "Enable additional FFmpeg tools"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-x265", "Enable x265 encoder"
  option "with-libsoxr", "Enable the soxr resample library"

  depends_on "pkg-config" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion
  depends_on "yasm" => :build

  depends_on "x264" => :recommended
  depends_on "lame" => :recommended
  depends_on "libvo-aacenc" => :recommended
  depends_on "xvid" => :recommended

  depends_on "faac" => :optional
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "libass" => :optional
  depends_on "openjpeg" => :optional
  depends_on "sdl" if build.with? "ffplay"
  depends_on "speex" => :optional
  depends_on "schroedinger" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "opus" => :optional
  depends_on "frei0r" => :optional
  depends_on "libcaca" => :optional
  depends_on "libbluray" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libquvi" => :optional
  depends_on "libvidstab" => :optional
  depends_on "x265" => :optional
  depends_on "openssl" => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--enable-shared",
            "--enable-pthreads",
            "--enable-gpl",
            "--enable-version3",
            "--enable-hardcoded-tables",
            "--enable-avresample",
            "--cc=#{ENV.cc}",
            "--host-cflags=#{ENV.cflags}",
            "--host-ldflags=#{ENV.ldflags}"
           ]

    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libxvid" if build.with? "xvid"

    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libvo-aacenc" if build.with? "libvo-aacenc"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-ffplay" if build.with? "ffplay"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-openssl" if build.with? "openssl"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libquvi" if build.with? "libquvi"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libx265" if build.with? "x265"
    args << "--disable-indev=qtkit" if build.without? "qtkit"

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << "--extra-cflags=" + %x[pkg-config --cflags libopenjpeg].chomp
    end

    # These librares are GPL-incompatible, and require ffmpeg be built with
    # the "--enable-nonfree" flag, which produces unredistributable libraries
    if %w[faac fdk-aac openssl].any? {|f| build.with? f}
      args << "--enable-nonfree"
    end

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no probles on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    if MacOS.version < :yosemite || ENV.compiler == :clang
      args << "--enable-vda"
    else
      args << "--disable-vda"
    end

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace "config.mak" do |s|
        shflags = s.get_make_var "SHFLAGS"
        if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
          s.change_make_var! "SHFLAGS", shflags
        end
      end
    end

    system "make", "install"

    if build.with? "tools"
      system "make", "alltools"
      bin.install Dir['tools/*'].select {|f| File.executable? f}
    end
  end

  def caveats
    if build.without? "faac" then <<-EOS.undent
      FFmpeg has been built without libfaac for licensing reasons.
      To install with libfaac, you can:
        brew reinstall ffmpeg --with-faac

      You can also use the libvo-acenc or experimental FFmpeg encoder to
      encode AAC audio:
        -c:a libvo_aacenc
      Or:
        -c:a aac -strict -2
      EOS
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/ffmpeg", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert (testpath/"video.mp4").exist?
  end
end
