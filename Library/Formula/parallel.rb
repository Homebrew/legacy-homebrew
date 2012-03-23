require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120322.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120322.tar.bz2'
  md5 'ceb12fd5eac4a9d2ca18ffebe970b0be'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
