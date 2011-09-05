require 'formula'

class Dcraw < Formula
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  url 'http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.10.tar.gz'
  md5 '1d523ee379ee96d1ec03cf99940a6207'

  depends_on 'jpeg'
  depends_on 'jasper'
  depends_on 'little-cms'

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms -ljasper"
    bin.install 'dcraw'
    man1.install 'dcraw.1'
  end
end
