require 'formula'

class Parallel < Formula
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120122.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'c90077522e95f2c255893fcec55907a8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
