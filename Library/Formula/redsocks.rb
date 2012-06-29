require 'formula'

class Redsocks < Formula
  homepage 'http://darkk.net.ru/redsocks'
  url 'https://github.com/darkk/redsocks/tarball/release-0.4'
  sha1 'd8c04e12efc168f6a3910b17e84682aa869afdce'

  depends_on 'libevent'

  def install
    system 'make'
    bin.install 'redsocks'
  end
end
