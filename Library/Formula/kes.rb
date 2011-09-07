require 'formula'

class Kes < Formula
  head 'https://github.com/epilnivek/kes.git'
  homepage 'https://github.com/epilnivek/kes'

  def install
    system "make"
    bin.install 'es'
    man1.install 'doc/es.1'
  end
end
