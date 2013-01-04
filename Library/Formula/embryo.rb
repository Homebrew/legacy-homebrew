require 'formula'

class Embryo < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Embryo'
  url 'http://download.enlightenment.org/releases/embryo-1.7.4.tar.gz'
  sha1 'f82ffaa0f2935c25e71dbdaf65885e55e114fe8e'

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
