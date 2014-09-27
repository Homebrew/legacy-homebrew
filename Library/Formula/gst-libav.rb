require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.1.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.4.1.tar.xz'
  sha256 'fc125521187fa84f3210269a0eecc51f8a856802f1ca4bb251f118dab90c5a9d'

  bottle do
    sha1 "bbdef0456e2b54ba44cd52aa8c546a0677530c7a" => :mavericks
    sha1 "09eda09dd7a2eec83a425358f7f5ebf08a19db2f" => :mountain_lion
    sha1 "0e0ece7c150767c232993122f9977ff129936576" => :lion
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
    system Formula["gstreamer"].opt_prefix/"bin/gst-inspect-1.0", "libav"
  end
end
