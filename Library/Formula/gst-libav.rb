require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.5.tar.xz'
  sha1 '7c186f82743cca7fb8fc78848d4e79c1d3bcd5e4'

  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "gst-inspect-1.0 libav"
  end
end
