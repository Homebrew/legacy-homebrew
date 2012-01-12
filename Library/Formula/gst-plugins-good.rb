require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.29.tar.bz2'
  sha256 '466a64dcb580d4feef701abfc90656abb3558a2e3fc1e40e43977034bebc354c'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-good-0.10.27/REQUIREMENTS and Homebrew formulas
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'check' => :optional
  depends_on 'aalib' => :optional
  depends_on 'libcdio' => :optional
  depends_on 'flac' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libdv' => :optional
  depends_on 'libshout' => :optional
  depends_on 'speex' => :optional
  depends_on 'taglib' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--disable-schemas-install",
                           "--disable-gtk-doc",
                           "--disable-goom",
                           "--with-default-videosink=ximagesink"
    system "make"
    system "make install"
  end
end
