class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.6.1.tar.xz"
  sha256 "3cbe332e18fd2eaf23ddeee96c414f79ac1edc2f7d990582fa0ec5f977bd04f1"

  bottle do
    revision 1
    sha256 "43dffd8e42d3ec66163589f72a42e0d9258519617825ae795111670c211b3da1" => :el_capitan
    sha256 "bbf99c94e9a3c18db045ce06d7d0a9819b5843d127609252f41f421664f89f43" => :yosemite
    sha256 "3f52ca606176db072962f21316b08df73196237695d9a133e930d2ba3dfebe5f" => :mavericks
  end

  depends_on "gst-plugins-base"
  depends_on "pygobject3"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    # pygi-overrides-dir switch ensures files don't break out of sandbox.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pygi-overrides-dir=#{lib}/python2.7/site-packages/gi/overrides"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
  end
end
