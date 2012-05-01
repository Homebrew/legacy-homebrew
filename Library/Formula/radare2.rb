require 'formula'

class Radare2 < Formula
  url 'http://radare.org/get/radare2-0.9.tar.gz'
  head 'http://radare.org/hg/radare2', :using => :hg
  homepage 'http://radare.org'
  md5 '751f0dc71f82b7689f10365ee3a5842f'

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
