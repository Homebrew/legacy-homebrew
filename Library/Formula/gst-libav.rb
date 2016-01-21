class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.6.3.tar.xz"
  sha256 "857b9c060a0337de38c6d26238c47352433c02eabf26c2f860c854dbc35bd4ab"

  bottle do
    sha256 "e4f84c4d4744007b19a070501ed39b4f7983c86c6a867e99863f45f2531edba1" => :el_capitan
    sha256 "44628b95c0e4420cf96d3a9f85e21321850d71f4020301c04a7ba49f574586e9" => :yosemite
    sha256 "263e2319b95f804c23ac46436a3a39e82a9a242225dcdaf8f22d215b1b5f551a" => :mavericks
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
