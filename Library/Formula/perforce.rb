require 'formula'

class Perforce < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4'
  homepage 'http://www.perforce.com/'
  md5 'cc65f148349c307a7f4c69ae15e5b883'
  version '2011.1.370818'

  def install
    bin.install 'p4'
  end
end
