class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.6.3.tar.xz"
  sha256 "857b9c060a0337de38c6d26238c47352433c02eabf26c2f860c854dbc35bd4ab"

  bottle do
    sha256 "04cfb1f456753fb8ef83827ac724e6cc50e517d4416aba9030d2cda2f78043fa" => :el_capitan
    sha256 "276225949d2a1e68e94949b168714a3cb8e0641f58b4145ae506a2b022544afc" => :yosemite
    sha256 "fe5bf35c1075d1f8a0c8d96b6500a5f4747e18235cb2498b72b767517fac1bae" => :mavericks
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
