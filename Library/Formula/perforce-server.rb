require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r11.1/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 'e431cca5a3ee56815794b682db4adad3'
  version '2011.1.370818'

  def install
    bin.install 'p4d'
  end
end
