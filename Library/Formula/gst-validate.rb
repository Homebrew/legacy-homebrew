class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "http://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.4.0.tar.xz"
  sha256 "ac30d1041a8cfe5d268439f5cedee7e9753ba49080fc67bff1266581198438d0"

  bottle do
    revision 1
    sha256 "450bf253e256d9031ad6ab0eb703e85d78e44b8bce2ad91090370abd5d7caf90" => :yosemite
    sha256 "b08355b9b695b2be027e9f162f36f8b18e98eb876e5c636c244a5dfb2b48e712" => :mavericks
    sha256 "e0d7815b3658c3227c49562c0c9ca532c66207df2e237e1977ce5dc159a2913f" => :mountain_lion
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
    inreplace "tools/gst-validate-launcher.in", "env python2", "env python"

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
