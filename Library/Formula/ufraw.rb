require 'formula'

class Ufraw <Formula
  url 'http://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.16/ufraw-0.16.tar.gz'
  homepage 'http://ufraw.sourceforge.net'
  md5 '61e100e42f17e3a7fcfae64506eebd14'

  depends_on 'pkg-config'
  depends_on 'glib'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'little-cms'
  depends_on 'dcraw'
  depends_on 'exiv2' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make install"
    (share+'pixmaps').rmtree
  end
end
