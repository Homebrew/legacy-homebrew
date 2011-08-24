require 'formula'

class Parallel < Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110522.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '83c12186d740698cddb3795420d0e1f8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
