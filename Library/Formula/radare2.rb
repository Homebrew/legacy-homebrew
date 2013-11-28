require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'https://github.com/radare/radare2/archive/0.9.6.tar.gz'
  sha1 'a0f6103adb9e7f17084b9553fd1629673a1d14ef'

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
