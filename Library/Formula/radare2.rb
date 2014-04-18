require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'http://radare.org/get/radare2-0.9.7.tar.xz'
  sha1 '34af6c6ba53ac08c852b4e110ac6908054616b9d'

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
