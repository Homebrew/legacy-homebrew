require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.20/ufraw-0.20.tar.gz'
  sha1 'f2f456c6ec5ab128433502eae05b82a7ed636f3e'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
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
