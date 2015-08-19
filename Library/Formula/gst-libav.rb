class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "http://gstreamer.freedesktop.org"
  url "http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.5.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.4.5.tar.xz"
  sha256 "605c62624604f3bb5c870844cc1f2711779cc533b004c2aa1d8c0d58557afbbc"

  bottle do
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
