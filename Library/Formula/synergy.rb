require 'formula'

class Synergy < Formula
  url 'http://synergy.googlecode.com/files/synergy-1.4.2-MacOSX106-Universal.zip'
  md5 'e52ca334612c3d01920c3beb927d93de'
  version '1.4.2'
  homepage 'http://synergy-foss.org'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
