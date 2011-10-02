require 'formula'

class Radare2 < Formula
  url 'http://radare.nopcode.org/get/radare2-0.7.tar.gz'
  head 'hg://http://hg.youterm.com/radare2'
  homepage 'http://radare.nopcode.org'
  md5 '468367eb881edad325823cabdef5d53d'

  depends_on 'libewf'
  depends_on 'libmagic'
  depends_on 'gmp'
  depends_on 'lua'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
