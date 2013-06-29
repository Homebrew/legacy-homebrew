require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.7.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.0.7.tar.xz'
  sha256 'aefa679d14e7a6558673cfbf401b9c01f1903bb52e5dc08332e9001d25a7ba7a'

  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{Formula.factory("gstreamer").opt_prefix}/bin/gst-inspect-1.0", "libav"
  end
end
