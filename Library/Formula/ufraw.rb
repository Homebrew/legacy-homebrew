require 'formula'

class Ufraw < Formula
  url 'http://sourceforge.net/project/downloading.php?group_id=127649&filename=ufraw-0.18.tar.gz'
  homepage 'http://ufraw.sourceforge.net'
  sha1 '41c9ad7aa7f1cbb63a6b0b330b3599b18a7e8cd2'

  depends_on 'pkg-config' => :build
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
