require 'formula'

class Kes < Formula
  homepage 'https://github.com/epilnivek/kes'
  url 'https://github.com/epilnivek/kes/tarball/v0.9'
  sha1 '07cd04ecd000a8bcb1b091c7573e095b1af64563'

  head 'https://github.com/epilnivek/kes.git'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-readline"
    system "make"
    bin.install 'es'
    man1.install 'doc/es.1'
  end
end
