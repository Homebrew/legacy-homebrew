require 'formula'

class Parallel <Formula
  url 'ftp://ftp.gnu.org/gnu/parallel/parallel-20100922.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'd394fda57fbe7a58f64b3c2eaa5ad177'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
