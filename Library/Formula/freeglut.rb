require 'formula'

class Freeglut < Formula
  homepage 'http://freeglut.sourceforge.net/'
  url 'http://sourceforge.net/projects/freeglut/files/freeglut/2.8.1/freeglut-2.8.1.tar.gz'
  sha1 '7330b622481e2226c0c9f6d2e72febe96b03f9c4'

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
  def patches
    "http://gist.github.com/yukota/5867264/raw/" if MacOS.version >= :lion
  end
end
