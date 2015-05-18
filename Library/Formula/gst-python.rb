class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
  sha256 "b1e40c29ceb41b03f08d38aca6056054f0341d0706276326dceeec6ac8d53d3e"
  revision 1

  bottle do
    sha256 "e27ac3a525070e5e9dbbd1128c5913c0e35d10efbff18eb2f5777e30323c45a9" => :yosemite
    sha256 "e4cea92475cb261c3a79e58fb6929a941484e29e38946bbdcdca5c359b5919b0" => :mavericks
    sha256 "37ba4c4a2db51c4f81709a70a8c89b23a631f471f8eaf7fde9d58eea96174b82" => :mountain_lion
  end

  depends_on "gst-plugins-base"
  depends_on "pygtk"
  depends_on "pygobject3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "gst-inspect-1.0", "python"
  end
end
