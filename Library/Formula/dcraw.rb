require 'formula'

class Dcraw < Formula
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  url 'http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.20.tar.gz'
  sha1 '9b8ca82eaaf6582ffa0f2602e8ca705c722ea87e'

  depends_on 'jpeg'
  depends_on 'jasper'
  depends_on 'little-cms2'

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms2 -ljasper"
    bin.install 'dcraw'
    man1.install 'dcraw.1'
  end
end
