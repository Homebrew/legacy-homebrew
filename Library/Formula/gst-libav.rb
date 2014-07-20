require 'formula'

class GstLibav < Formula
  homepage 'http://gstreamer.freedesktop.org'
  url 'http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.2.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-libav-1.2.4.tar.xz'
  sha256 '2a69480d63fc2db93249d9e2e229ab3541bbc2db881b0f64de13d0bfc7d1f037'

  bottle do
    sha1 "628e74ce93cb4c7ccc6ee6918b8d826b7d4e5889" => :mavericks
    sha1 "5db394b3f092af5a8b022bbc0d31c6359de46e6b" => :mountain_lion
    sha1 "d58170be4bfdbec2b309aaad06456827c503b71d" => :lion
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
