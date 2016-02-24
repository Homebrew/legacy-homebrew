class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.6.0.tar.xz"
  sha256 "3baef8c7b5363293c20314a30afd54629849fc597669991fdcf92303602dafee"

  bottle do
    sha256 "338d8f489811e92491ad6d86a96c76ac6056b6e178bb5caa412f73feff9b7d8f" => :el_capitan
    sha256 "46a75949ef97e6cfa1e1996886ebd34e1446752600e9308ce904ead70386ac19" => :yosemite
    sha256 "8d11ac9dc97c9f85f941ad6d684b3e2640795f02d02338562dd5e9a9da7f23f2" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

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
