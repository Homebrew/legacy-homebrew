class GstPluginsBad < Formula
  desc "GStreamer plugins (less supported, missing docs, not fully tested)"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.5.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.4.5.tar.xz"
  sha256 "152fad7250683d72f9deb36c5685428338365fe4a4c87ffe15e38783b14f983c"

  bottle do
    revision 1
    sha256 "e853f0c985b9e4a8b38c85b415d939bced34bceb70a95949e096f1bbca735ee3" => :el_capitan
    sha256 "c4cb9cf4187786a73e43618260378e3db8cff3887acf3f352a1a549373f0340d" => :yosemite
    sha256 "5280b336808a878ba93477d5664d6f784e2f78f6880b5ea267adcd93e7e7f38b" => :mavericks
    sha256 "1de5eb524831527facb2f91df2c8b7292aca6d7e72f3c454116f3c67989edcba" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-bad"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "openssl"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"

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

  option "with-applemedia", "Build with applemedia support"

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
