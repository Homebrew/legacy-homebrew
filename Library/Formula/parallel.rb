require 'formula'

class Parallel < Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110722.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'fddfaad6e944e7d6609bf110f9a562cc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
