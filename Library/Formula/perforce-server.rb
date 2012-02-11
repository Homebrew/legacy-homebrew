require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '9099ad567f43cc7bb0821492a1eb3fe6'
  version '2011.1.409024'

  def install
    bin.install 'p4d'
  end
end
