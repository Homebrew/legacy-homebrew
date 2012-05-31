require 'formula'

class Kes < Formula
  homepage 'https://github.com/epilnivek/kes'
  url 'https://github.com/epilnivek/kes/tarball/v0.9'
  md5 '6ea08b27d49685a261e8de74c8428158'

  head 'https://github.com/epilnivek/kes.git'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-readline"
    system "make"
    bin.install 'es'
    man1.install 'doc/es.1'
  end
end
