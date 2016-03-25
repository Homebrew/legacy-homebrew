class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.8.0.tar.xz"
  sha256 "5a1ce28876aee93cb4f3d090f0e807915a5d9bc1325e3480dd302b85aeb4291c"

  bottle do
    sha256 "04cfb1f456753fb8ef83827ac724e6cc50e517d4416aba9030d2cda2f78043fa" => :el_capitan
    sha256 "276225949d2a1e68e94949b168714a3cb8e0641f58b4145ae506a2b022544afc" => :yosemite
    sha256 "fe5bf35c1075d1f8a0c8d96b6500a5f4747e18235cb2498b72b767517fac1bae" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-libav.git"

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
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
