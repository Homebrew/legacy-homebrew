class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-11.4.tar.xz"
  sha256 "0b7dabc2605f3a254ee410bb4b1a857945696aab495fe21b34c3b6544ff5d525"
  revision 2

  head "https://git.libav.org/libav.git"

  bottle do
    revision 1
    sha256 "3223c7dd692ab5f842161c25bd000dc7e35e4dbd115075e689f24761917c3b28" => :el_capitan
    sha256 "918a06af5462bb2854099ff9df522f03d86d2913961305a0ea250cae48058f95" => :yosemite
    sha256 "4d67498870e513e072c2ccbbf43f23657bb90dc6c2871d52221902823bcfbf40" => :mavericks
  end

  option "without-faac", "Disable AAC encoder via faac"
  option "without-lame", "Disable MP3 encoder via libmp3lame"
  option "without-x264", "Disable H.264 encoder via x264"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder via xvid"

  option "with-opencore-amr", "Enable AMR-NB de/encoding and AMR-WB decoding " \
    "via libopencore-amrnb and libopencore-amrwb"
  option "with-openjpeg", "Enable JPEG 2000 de/encoding via OpenJPEG"
  option "with-openssl", "Enable SSL support"
  option "with-rtmpdump", "Enable RTMP protocol support"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-sdl", "Enable avplay"
  option "with-speex", "Enable Speex de/encoding via libspeex"
  option "with-theora", "Enable Theora encoding via libtheora"
  option "with-libvorbis", "Enable Vorbis encoding via libvorbis"
  option "with-libvo-aacenc", "Enable VisualOn AAC encoder"
  option "with-libvpx", "Enable VP8 de/encoding via libvpx"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion

  depends_on "faac" => :recommended
  depends_on "lame" => :recommended
  depends_on "x264" => :recommended
  depends_on "xvid" => :recommended

  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "frei0r" => :optional
  depends_on "gnutls" => :optional
  depends_on "libvo-aacenc" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openjpeg" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sdl" => :optional
  depends_on "speex" => :optional
  depends_on "theora" => :optional

  # Fixes the use of a removed identifier in libvpx;
  # will be fixed in the next release.
  patch do
    url "https://github.com/libav/libav/commit/4d05e9392f84702e3c833efa86e84c7f1cf5f612.patch"
    sha256 "78f02e231f3931a6630ec4293994fc6933c6a1c3d1dd501989155236843c47f9"
  end

  def install
    args = [
      "--disable-debug",
      "--disable-shared",
      "--disable-indev=jack",
      "--prefix=#{prefix}",
      "--enable-gpl",
      "--enable-nonfree",
      "--enable-version3",
      "--enable-vda",
      "--cc=#{ENV.cc}",
      "--host-cflags=#{ENV.cflags}",
      "--host-ldflags=#{ENV.ldflags}",
    ]

    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-gnutls" if build.with? "gnutls"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libopencore-amrnb" if build.with? "opencore-amr"
    args << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libopenjpeg" if build.with? "openjpeg"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvo-aacenc" if build.with? "libvo-aacenc"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args

    system "make"

    bin.install "avconv", "avprobe"
    man1.install "doc/avconv.1", "doc/avprobe.1"
    if build.with? "sdl"
      bin.install "avplay"
      man1.install "doc/avplay.1"
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/avconv", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert (testpath/"video.mp4").exist?
  end
end
