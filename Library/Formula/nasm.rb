require 'brewkit'

class Nasm <Formula
  @url='http://www.nasm.us/pub/nasm/releasebuilds/2.07/nasm-2.07.tar.bz2'
  @homepage='http://www.nasm.us/'
  @md5='d8934231e81874c29374ddef1fbdb1ed'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
