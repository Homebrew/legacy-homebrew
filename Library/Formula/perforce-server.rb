require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '8ef3580d6e8d2575ae910eec002c8c55'
  version '2011.1.397313'

  def install
    bin.install 'p4d'
  end
end
