require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'http://radare.org/get/radare2-0.9.2.tar.gz'
  sha1 '7cfa170a59453d57361d730f4c4a1495d36930a8'

  head 'http://radare.org/hg/radare2', :using => :hg

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
