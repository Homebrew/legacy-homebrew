require 'formula'

class Kes < Formula
  homepage 'https://github.com/epilnivek/kes'
  head 'https://github.com/epilnivek/kes.git'
  # Requested stable version:
  # https://github.com/epilnivek/kes/issues/8

  def install
    system "make"
    bin.install 'es'
    man1.install 'doc/es.1'
  end
end
