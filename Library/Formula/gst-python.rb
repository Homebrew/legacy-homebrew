class GstPython < Formula
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
  version "1.4.0"
  sha256 "b1e40c29ceb41b03f08d38aca6056054f0341d0706276326dceeec6ac8d53d3e"

  head do
    url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.4.0.tar.xz"
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
  do test
    system "gst-inspect-1.0", "-vd", "python"
  end
end
