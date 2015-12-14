class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.6.2.tar.xz"
  sha256 "2597acc00171006d49f0d300440a87df51b113d557466e532153abc740db3469"

  bottle do
    sha256 "10b4dfaf8462d84b49d191d8efaa3f34383433ae3a664963a0246140d105b4b0" => :el_capitan
    sha256 "71a4eb44fd8e4d74031473b15d00237288ac6d289c5e76179ed1d354e7093b56" => :yosemite
    sha256 "bcfc32e1606fc0cfa056465f32688d853e3fcca15e1a00a3c9fceef80bf222ec" => :mavericks
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
