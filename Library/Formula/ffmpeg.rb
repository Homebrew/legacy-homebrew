class Ffmpeg < Formula
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.6.1.tar.bz2"
  sha256 "a4f6388706ee2daba9d35d2aa018ae5feeb450efa716555e011a6543d43ec7c1"

  head "git://source.ffmpeg.org/ffmpeg.git"

  bottle do
    sha256 "8bc0cb43f99a7004aada9969875e551a24ebe2e57b8c620aa77b70372ba7fa0f" => :yosemite
    sha256 "2ab2f322d8a1ce26af77b7f86e45e8af1c1cf6f01a51d05e460a1282ab84cbec" => :mavericks
    sha256 "dd2629269914f801e5c16b5c8ba3abebbc48ab7417a54852f1cb74aee8c04875" => :mountain_lion
  end

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-libvo-aacenc", "Disable VisualOn AAC encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"
  option "without-qtkit", "Disable deprecated QuickTime framework"

  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-ffplay", "Enable FFplay media player"
  option "with-tools", "Enable additional FFmpeg tools"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-x265", "Enable x265 encoder"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-webp", "Enable using libwebp to encode WEBP images"

  depends_on "pkg-config" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build
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
  depends_on "libssh" => :optional
  depends_on "webp" => :optional

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
            "--host-ldflags=#{ENV.ldflags}",
           ]

    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libvo-aacenc" if build.with? "libvo-aacenc"
    args << "--enable-libxvid" if build.with? "xvid"

    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-ffplay" if build.with? "ffplay"
    args << "--enable-libssh" if build.with? "libssh"
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
    args << "--enable-libwebp" if build.with? "webp"
    args << "--disable-indev=qtkit" if build.without? "qtkit"

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << "--extra-cflags=" + %x(pkg-config --cflags libopenjpeg).chomp
    end

    # These librares are GPL-incompatible, and require ffmpeg be built with
    # the "--enable-nonfree" flag, which produces unredistributable libraries
    if %w[faac fdk-aac openssl].any? { |f| build.with? f }
      args << "--enable-nonfree"
    end

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    if MacOS.version < :yosemite || ENV.compiler == :clang
      args << "--enable-vda"
    else
      args << "--disable-vda"
    end

    # For 32-bit compilation under gcc 4.2, see:
    # https://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

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
      bin.install Dir["tools/*"].select { |f| File.executable? f }
    end
  end

  def caveats
    if build.without? "faac" then <<-EOS.undent
      FFmpeg has been built without libfaac for licensing reasons;
      libvo-aacenc is used by default.
      To install with libfaac, you can:
        brew reinstall ffmpeg --with-faac

      You can also use the experimental FFmpeg encoder, libfdk-aac, or
      libvo_aacenc to encode AAC audio:
        ffmpeg -i input.wav -c:a aac -strict experimental output.m4a
      Or:
        brew reinstall ffmpeg --with-fdk-aac
        ffmpeg -i input.wav -c:a libfdk_aac output.m4a
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
