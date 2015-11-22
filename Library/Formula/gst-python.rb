class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "http://gstreamer.freedesktop.org/modules/gst-python.html"
  url "http://gstreamer.freedesktop.org/src/gst-python/gst-python-1.6.1.tar.xz"
  sha256 "3cbe332e18fd2eaf23ddeee96c414f79ac1edc2f7d990582fa0ec5f977bd04f1"

  bottle do
    sha256 "4e4e6c99a7300ec2905e0f2fb8fb64ab5e3beec4365dd6c200240133e24cdb88" => :el_capitan
    sha256 "94c32194e05e6522a6d8cd3deba62ed1eb1a59a06a67e611f19cc10398fe8ba3" => :yosemite
    sha256 "c660e3c9b4f476bf63a84ff4e942ed2903a84fedb62015914e9629585c4db419" => :mavericks
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
