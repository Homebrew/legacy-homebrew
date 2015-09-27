class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.6.0.tar.xz"
  sha256 "6cca6cf73182a882768ef0c860af88c2fd2c77e2c81ce464a998ab4e6baa604c"

  bottle do
    sha256 "794810f2c445e8217ed8db0701f5a9098a4c62661f25c7222cb416ae78aae854" => :el_capitan
    sha1 "b1deaafa0ea7ab50ffc14706ceedc0465846af58" => :yosemite
    sha1 "812d25e4e2bd610bdd1b9f1202dc27e5fb645c50" => :mavericks
    sha1 "7e147f585f4674346454b43099d003a9dc42f083" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-libav"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
