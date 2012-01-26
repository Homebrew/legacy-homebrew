require 'formula'

class Synergy < Formula
  # Newer 1.3.x versions have a critical bug on OS X:
  # http://code.google.com/p/synergy-plus/issues/detail?id=47
  # Do not bump this to 1.3.7 or newer until that issue is resolved.
  url 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip'
  sha1 '5b9336fb553db17bd109e3f2bca517af18ed3863'
  version '1.3.6p2'
  homepage 'http://synergy-foss.org'

  devel do
    url 'http://synergy.googlecode.com/files/synergy-1.4.3-MacOSX106-Universal.zip'
    sha1 'aa60fa6ac975dd22dc095d6cd9f3dc755b91bb64'
    version '1.4.3'
  end

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
