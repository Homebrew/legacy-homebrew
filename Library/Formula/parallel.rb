require 'formula'

class Parallel <Formula
  url 'ftp://ftp.gnu.org/gnu/parallel/parallel-20100906.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'e8a50e2398ce359c19b5f56832946978'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
