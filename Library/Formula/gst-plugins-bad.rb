class GstPluginsBad < Formula
  desc "GStreamer plugins (less supported, missing docs, not fully tested)"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.6.3.tar.xz"
  sha256 "971b29101d6a9c5e3fe94d99d977a227f58f0b2d29b6ca2c7f292052542b3a61"

  bottle do
    sha256 "62fe5bada427937462a1f987a51610238dc2a93ebdcd49125f32f0d6c12aadbd" => :el_capitan
    sha256 "370942a6751b7cc5d585cc8d9b6bfb80fc7939fa5a4cce203a3eb0bff8aefdfe" => :yosemite
    sha256 "09cb36ec9d229934dfa9a04830e737c972ee3bbeb7406be50f5d257dfa2e19af" => :mavericks
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
