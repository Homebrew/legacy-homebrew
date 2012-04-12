require 'formula'

class Ttf2eot < Formula
  url 'http://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz'
  homepage 'http://code.google.com/p/ttf2eot/'
  md5 '97c9ceb0ded362bf2e6dd3a3a9360f8d'

  def install
    system "make"
    bin.install 'ttf2eot'
  end
end
