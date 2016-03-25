class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.8.0.tar.xz"
  sha256 "ce45ff17c59f86a3a525685e37b95e6a78a019e709f66a5c4b462a7f7a22f6ea"

  bottle do
    sha256 "2238face2977ef583ca91be6c14af2eff18627b613e71d4323b6d5127aa4df08" => :el_capitan
    sha256 "d2fde997e41000ced229cd3a6a309f4230fe7a278f54104506ebcbaff7b2fc5e" => :yosemite
    sha256 "0f152b4f04998d1e2ace57b736318026c08e68d5c76c596c2cfa0d465cc525c6" => :mavericks
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
