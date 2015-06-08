class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "http://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.4.0.tar.xz"
  sha256 "ac30d1041a8cfe5d268439f5cedee7e9753ba49080fc67bff1266581198438d0"

  bottle do
    sha256 "f5dca749834de5b432007b4c2f3d88dd1aaf1b144b5209318c62fa62a75d8c51" => :yosemite
    sha256 "3f916cd3acd23dac5159684f709c0944c0977a057b25aec0072bd2312a62fb25" => :mavericks
    sha256 "a19857658ef39937d9702c20d271068edad58f31e2e9d7fa64278c672d920694" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-devtools"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      cd "validate" do
        system "./autogen.sh"
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    else
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
