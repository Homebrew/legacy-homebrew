require 'formula'

class Kes < Formula
  homepage 'https://github.com/epilnivek/kes'
  url 'https://github.com/epilnivek/kes/archive/v0.9.tar.gz'
  sha1 '483ff8c76372bc12a852ae10d8d5edc7591cfe09'

  head 'https://github.com/epilnivek/kes.git'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-readline"
    system "make"
    bin.install 'es'
    man1.install 'doc/es.1'
  end
end
