require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.6.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.0.6.tar.xz'
  sha256 '8ab222a52bf7482e913f2c9a4f490cda8f8ed1acfbc429f27451b0558b08044d'

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
