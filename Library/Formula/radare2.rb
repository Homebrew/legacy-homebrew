require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'http://radare.org/get/radare2-0.9.6.tar.xz'
  sha1 'a12a2de9588d9925d32e1fb2e1942e491c602358'

  head 'https://github.com/radare/radare2.git'

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
