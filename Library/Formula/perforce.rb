require 'formula'

class Perforce < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4'
  homepage 'http://www.perforce.com/'
  md5 '36b710330cc3f6ba4b75962b2a02302a'
  version '2011.1.393975'

  def install
    bin.install 'p4'
  end
end
