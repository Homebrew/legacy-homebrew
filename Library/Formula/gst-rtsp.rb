class GstRtsp < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.4.5.tar.xz"
  sha256 "3089254bd31b7c1f1cf2c034a3b3551f92878f9e3cab65cef3a901a04c0f1d37"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"

  def install
    system "./configure",  "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}", "--disable-gtk-doc"
    system "make"
    system "make", "install"
  end
end
