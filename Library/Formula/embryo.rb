require 'formula'

class Embryo < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Embryo'
  url 'http://download.enlightenment.org/releases/embryo-1.7.9.tar.gz'
  sha1 '1644da0be669213ce9ed29f1b58e9c6f3ab7c05c'

  head do
    url 'http://svn.enlightenment.org/svn/e/trunk/embryo/'

    depends_on :autoconf
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
