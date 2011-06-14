require 'formula'

class Synergy < Formula

  if ARGV.build_head?
    url 'http://synergy.googlecode.com/files/synergy-1.4.2-MacOSX106-Universal.zip'
    md5 'e52ca334612c3d01920c3beb927d93de'
    version '1.4.2'
  else
    url 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip'
    md5 'd7eba8d3ee9d50caa1d8c00d27702879'
    version '1.3.6'
  end

  homepage 'http://synergy-foss.org'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
