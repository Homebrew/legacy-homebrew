require 'formula'

class Synergy < Formula
  url 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip'
  md5 'd7eba8d3ee9d50caa1d8c00d27702879'
  version '1.3.6p2'
  homepage 'http://synergy-foss.org'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
