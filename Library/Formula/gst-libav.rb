require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.4.4.tar.xz'
  sha256 '2ec7285e5ec6731963b0955487cceb9eb04e285ca682f3ef575996c068cde8aa'

  bottle do
    sha1 "77e0e0a6e08f928fb68b491bad6d0115490e2cef" => :yosemite
    sha1 "5b9ab2328c5c6d5970e085f816d9299252d5ffd3" => :mavericks
    sha1 "918fd6f368ff1983e6fd8ee985f08c956f48a6cc" => :mountain_lion
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
