require 'formula'

class Geeqie < Formula
  homepage 'http://geeqie.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/geeqie/geeqie/geeqie-1.0/geeqie-1.0.tar.gz'
  sha1 '8494a557d67d20e6ad720645ec789dd2b33a3266'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'imagemagick' => :recommended
  depends_on 'exiv2' => :recommended
  depends_on 'little-cms' => :recommended
  depends_on 'fbida' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest"
    system "make install"
  end
end
