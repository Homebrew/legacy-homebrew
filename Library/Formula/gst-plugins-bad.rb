class GstPluginsBad < Formula
  desc "GStreamer plugins (less supported, missing docs, not fully tested)"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.6.1.tar.xz"
  sha256 "e176a9af125f6874b3d6724aa7566a198fa225d3ece0a7ac2f2b51c57e525466"

  bottle do
    sha256 "2de786143627ce949fd3bb7f3dae6cb9cc9110b42072061d60206f55ea381826" => :el_capitan
    sha256 "87249ebeb2cbb133a5cf75c1c4f272df0ca1583659642d5588572e30c62c6257" => :yosemite
    sha256 "f6b52b9c2d0ce7901b36af8ac2e393c8290fd882eaf43d0a1b4a6886cc53e74f" => :mavericks
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-bad"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-applemedia", "Build with applemedia support"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "openssl"

  depends_on "dirac" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "gnutls" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libmms" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srtp" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    args << "--disable-apple_media" if build.without? "applemedia"

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
