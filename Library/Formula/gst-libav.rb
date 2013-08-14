require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.0.9.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.0.9.tar.xz'
  sha256 '759641c0597c24191322f40945b363b75df299a539ff4086650be6193028189a'

  head 'git://anongit.freedesktop.org/gstreamer/gst-libav'

  if build.head?
    depends_on :automake
    depends_on :libtool
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"]="yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula.factory("gstreamer").opt_prefix}/bin/gst-inspect-1.0", "libav"
  end
end
