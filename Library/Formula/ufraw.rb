require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'http://sourceforge.net/project/downloading.php?group_id=127649&filename=ufraw-0.19.tar.gz'
  sha1 '0f77a7050e42e5b6197e0e513dda723eec2b2386'

  depends_on 'pkg-config' => :build
  depends_on :libpng
  depends_on 'glib'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'little-cms'
  depends_on 'dcraw'
  depends_on 'exiv2' => :optional

  fails_with :llvm do
    cause "Segfault while linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make install"
    (share+'pixmaps').rmtree
  end
end
