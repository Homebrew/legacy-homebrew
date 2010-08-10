require 'formula'

class Nasm <Formula
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.08.01/nasm-2.08.01.tar.bz2'
  homepage 'http://www.nasm.us/'
  md5 '1e3ebc1289c2be5963571c0937b7a211'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
