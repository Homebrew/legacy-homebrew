require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.0.8.tar.xz'
  sha256 'e6e538290e585c993609337761d894dd1b6b53ef625798b2a511d5314579995f'

  head 'git://anongit.freedesktop.org/gstreamer/gst-libav'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "yasm"
  depends_on "gst-plugins-base"

  def install
    ENV.append "NOCONFIGURE", "yes" if build.head?

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--enable-debug" if build.head?
    args << "--enable-dependency-tracking" if build.head?

    args << "--disable-debug" if not build.head?
    args << "--disable-dependency-tracking" if not build.head?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{Formula.factory("gstreamer").opt_prefix}/bin/gst-inspect-1.0", "libav"
  end
end
