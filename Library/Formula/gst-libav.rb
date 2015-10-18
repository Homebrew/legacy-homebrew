class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.6.0.tar.xz"
  sha256 "6cca6cf73182a882768ef0c860af88c2fd2c77e2c81ce464a998ab4e6baa604c"

  bottle do
    sha256 "0f24e12e8dcecd40a561fc75b53e0d2435da03236a0aa56bbafd02ffa31c2825" => :el_capitan
    sha256 "b779cfa2dafc69decb29fd0fa6f18ed5da1b4c745ed2f3f663f3822651dd31ba" => :yosemite
    sha256 "667ad19a7b15d2cba56aca4867f3efdaeef7b6690a3c9bf2403c42dc6673d561" => :mavericks
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
  depends_on "xz" # For LZMA

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
