require 'formula'

class Radare2 < Formula
  url 'http://radare.org/get/radare2-0.9.tar.gz'
  head 'http://radare.org/hg/radare2', :using => :hg
  homepage 'http://radare.org'
  sha1 'e77c85b001d9308f38a336b26544836fbe1d14dc'

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
