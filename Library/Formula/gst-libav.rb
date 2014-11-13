require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.4.4.tar.xz'
  sha256 '2ec7285e5ec6731963b0955487cceb9eb04e285ca682f3ef575996c068cde8aa'

  bottle do
    revision 1
    sha1 "9514efedab2cd85c4d60e3b4f5d476875a4e5a00" => :yosemite
    sha1 "d3453277643884a602ec17d238ffc340a226dbd4" => :mavericks
    sha1 "0dee620b9b88c01181a42f8e4915c5a86be4a274" => :mountain_lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-libav'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
