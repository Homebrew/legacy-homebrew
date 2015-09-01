class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
  sha256 "b1e40c29ceb41b03f08d38aca6056054f0341d0706276326dceeec6ac8d53d3e"
  revision 1

  bottle do
    revision 1
    sha256 "23cc5d7ab90a98cb8baf83cff0b8c1f46077ed9171f1aa8b8a28db963f8d6039" => :yosemite
    sha256 "40fda115c1425f67ec25228f86d902c7cbc4522bc71cc7daedce37f04041a1cf" => :mavericks
    sha256 "d3b34dcf00708c39721a1696a9bea2ef5fe3144ef1dad200971e063654d372eb" => :mountain_lion
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
