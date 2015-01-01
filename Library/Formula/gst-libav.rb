require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.5.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.4.5.tar.xz'
  sha256 "605c62624604f3bb5c870844cc1f2711779cc533b004c2aa1d8c0d58557afbbc"

  bottle do
    sha1 "55fc0142b58d7153186a57da25fa1064ed8c5e04" => :yosemite
    sha1 "9237462819fde170a0470810ed2f9458be2a5599" => :mavericks
    sha1 "e5caa7366d17298c379ddacbf1e030cd3dc6f6c6" => :mountain_lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-libav'

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
