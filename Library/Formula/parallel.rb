require 'formula'

class Parallel <Formula
  url 'ftp://ftp.gnu.org/gnu/parallel/parallel-20100424.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '7f75ec6bd43768f27aa2667a3f4ce96d'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
