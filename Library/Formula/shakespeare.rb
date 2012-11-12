require 'formula'

class Shakespeare < Formula
  homepage 'http://shakespearelang.sourceforge.net/'
  url 'http://shakespearelang.sf.net/download/spl-1.2.1.tar.gz'
  sha1 '17adea7bbf5e1de1a29e71b19e5271f186e9698d'

  def install
    system "make install"
    bin.install 'spl/bin/spl2c'
    include.install 'spl/include/spl.h'
    lib.install 'spl/lib/libspl.a'
  end
end
