class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.6.0.tar.xz"
  sha256 "60dbc7f5ac2b6655ed4a7ed2cee63ee5a525d37cb16eaa6b9df7d7dfe4e9605f"

  bottle do
    sha256 "2493558defcd65f0b0f486344e679f594feef4b550fd15f4f6946dbaaeab2ef9" => :el_capitan
    sha256 "2f874fe16da1680cf209939e708b8806a54cfa5336deaf6f9e2097e257277eaf" => :yosemite
    sha256 "94059057636ee841d5cd0474c7f62bb9400b2a7236ca1da09c5593d866d3d81f" => :mavericks
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
