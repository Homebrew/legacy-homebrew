require 'formula'

class Parallel < Formula
  url 'http://ftpmirror.gnu.org/parallel/parallel-20111122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20111122.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '3948c2b58553687451f0aef54a4d30d6'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
