require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.19.2/ufraw-0.19.2.tar.gz'
  sha1 '11a607e874eb16453a8f7964e4946a29d18b071d'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'dcraw'
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'exiv2' => :optional

  # Fixes compilation with clang 3.4; fixed upstream
  # http://sourceforge.net/p/ufraw/bugs/365/
  patch :p0 do
    url "https://trac.macports.org/export/115801/trunk/dports/graphics/ufraw/files/cplusplus.patch"
    sha1 "eb6a782625ba99dc2dcdaf574734734d17a75562"
  end

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
