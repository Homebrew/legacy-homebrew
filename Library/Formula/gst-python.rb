class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
  sha256 "b1e40c29ceb41b03f08d38aca6056054f0341d0706276326dceeec6ac8d53d3e"

  bottle do
    revision 1
    sha256 "6e21cb7f62dc2d6ef248cd001053e365c8a4e337fd53daad66b9a701ced1e10a" => :yosemite
    sha256 "7360fc4d530557e1984398a521f928e1d0ecdd321a15608161ceede201a85b35" => :mavericks
    sha256 "2683cfdbd77a6537048890a08a907d476f470a6b7178434a6831495e712082de" => :mountain_lion
  end

  depends_on "gst-plugins-base"
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
