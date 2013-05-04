require 'formula'

class Embryo < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Embryo'
  url 'http://download.enlightenment.org/releases/embryo-1.7.5.tar.gz'
  sha1 'e6d6c5d83a265042dc6f8225720c211b3beb3bcf'

  head 'http://svn.enlightenment.org/svn/e/trunk/embryo/'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'eina'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
