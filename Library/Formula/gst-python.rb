class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.8.0.tar.xz"
  sha256 "ce45ff17c59f86a3a525685e37b95e6a78a019e709f66a5c4b462a7f7a22f6ea"

  bottle do
    sha256 "0db481be4a44e4a9901a88bb1cc2b4b0d61b2ae860552da2b67b816b5f1dcee1" => :el_capitan
    sha256 "b214748955c3695f29b3e01cd747827c26a8f965814decfa1aca885a4855ab39" => :yosemite
    sha256 "d8c516e3a67d13905b4dac5401c7cf78e2a8836bb4555b7bda4916f9222c11c1" => :mavericks
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
