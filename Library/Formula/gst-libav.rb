class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.8.0.tar.xz"
  sha256 "5a1ce28876aee93cb4f3d090f0e807915a5d9bc1325e3480dd302b85aeb4291c"

  bottle do
    sha256 "4148307a8895c277eafd9257a26123d0b15a765de8957b5a469ee6d4576bde56" => :el_capitan
    sha256 "eef873207410841f166f616cc357242e8faca5942fb63716c3e63f91d35b3dd1" => :yosemite
    sha256 "52363512965813a8794da326a89e60855751211b0ad39ad7772c877803bdd7dc" => :mavericks
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
