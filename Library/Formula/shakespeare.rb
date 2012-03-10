require 'formula'

class Shakespeare < Formula
  url 'http://shakespearelang.sf.net/download/spl-1.2.1.tar.gz'
  homepage 'http://shakespearelang.sourceforge.net/'
  md5 'c31de8415af80819eb944a1cecadddde'

  def install
    system "make install"
    bin.install 'spl/bin/spl2c'
    include.install 'spl/include/spl.h'
    lib.install 'spl/lib/libspl.a'
    prefix.install 'NEWS'   # Also include NEWS file in prefix, why not?
  end
end
