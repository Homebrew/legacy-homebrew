require 'formula'

class Geeqie < Formula
  homepage 'http://geeqie.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/geeqie/geeqie/geeqie-1.1/geeqie-1.1.tar.gz'
  sha1 '77167479e91e03d9512535a146c5d2d77941257f'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'gnu-getopt'
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
