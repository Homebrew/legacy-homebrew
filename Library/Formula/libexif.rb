require 'formula'

class Libexif <Formula
  url 'http://downloads.sourceforge.net/project/libexif/libexif/0.6.19/libexif-0.6.19.tar.bz2'
  homepage 'http://libexif.sourceforge.net/'
  md5 '56144a030a4c875c600b1ccf713f69f7'

  def install
    fails_with_llvm "segfault with llvm"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
