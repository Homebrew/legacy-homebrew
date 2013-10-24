require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.0.8.tar.xz'
  sha256 'e6e538290e585c993609337761d894dd1b6b53ef625798b2a511d5314579995f'

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
