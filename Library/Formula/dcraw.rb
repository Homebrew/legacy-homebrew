require 'formula'

class Dcraw <Formula
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  url 'http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.05.tar.gz'
  md5 'b06ad99909ede5f1a129fa4b53d32e04'

  depends_on 'jpeg'
  depends_on 'little-cms'

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw/dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms"
    bin.install 'dcraw/dcraw'
    man1.install 'dcraw.1'
  end
end
