require 'formula'

class Parallel < Formula
  url 'http://ftpmirror.gnu.org/parallel/parallel-20111022.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'ed5710d204fe8981ba44f771af72955b'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
