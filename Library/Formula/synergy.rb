require 'formula'

class Synergy <Formula
  url 'http://downloads.sourceforge.net/project/synergy2/Binaries/1.3.1/synergy-1.3.1-1.OSX.tar.gz'
  homepage 'http://sourceforge.net/projects/synergy2/'
  md5 '19f8b396161a5bad982e6b7a06459a37'
  version '1.3.1'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
