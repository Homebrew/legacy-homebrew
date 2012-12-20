require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20121122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20121122.tar.bz2'
  sha256 '0315336141612ba2ec1f76e6c8c58a72f4531777c96b79b91ef64b3980be584f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
