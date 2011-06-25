require 'formula'

class Nasm < Formula
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.09/nasm-2.09.tar.bz2'
  homepage 'http://www.nasm.us/'
  md5 'bf224f073b3181186114c93e6695e6ac'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
