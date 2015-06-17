class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
  sha256 "b1e40c29ceb41b03f08d38aca6056054f0341d0706276326dceeec6ac8d53d3e"

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
