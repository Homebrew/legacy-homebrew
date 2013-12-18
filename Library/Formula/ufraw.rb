require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.19.2/ufraw-0.19.2.tar.gz'
  sha1 '11a607e874eb16453a8f7964e4946a29d18b071d'

  depends_on 'pkg-config' => :build
  depends_on :libpng
  depends_on 'dcraw'
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
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
