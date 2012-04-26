require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120422.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120422.tar.bz2'
  sha1 '1f0e9bdca7271fa6932a570980b8a3b335b2eaa5'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
