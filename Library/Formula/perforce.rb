require 'formula'

class Perforce < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4'
  homepage 'http://www.perforce.com/'
  md5 'a5af98fc860315aa35e606f912aa97ab'
  version '2011.1.389946'

  def install
    bin.install 'p4'
  end
end
