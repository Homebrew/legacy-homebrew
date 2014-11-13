require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.20/ufraw-0.20.tar.gz'
  sha1 'f2f456c6ec5ab128433502eae05b82a7ed636f3e'

  bottle do
    sha1 "114f5807e129d36cf97186160ead6003adb5b6fa" => :yosemite
    sha1 "3604acf00a45b6e569b264d2e482626214731ca8" => :mavericks
    sha1 "2ee9849f3b51f2702f67a6626539fcae5a9a6f04" => :mountain_lion
  end

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
