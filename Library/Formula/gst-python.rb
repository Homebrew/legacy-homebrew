class GstPython < Formula
  desc "GStreamer Python overrides for gobject-introspection-based pygst bindings"
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

  def install
    # ensure files are kept inside the keg
    # this patch is necessary as long as gobject-introspection requires :python on older OS X releases
    inreplace "gi/overrides/Makefile.in", "$(PYGI_OVERRIDES_DIR)", "@libdir@/python2.7/site-packages/gi/overrides" if MacOS.version <= :mavericks
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
