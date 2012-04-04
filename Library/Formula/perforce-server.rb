require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '7809e0bc85cc7672c5dfa77c33b70336'
  version '2011.1.428451'

  def install
    bin.install 'p4d'
  end
end
