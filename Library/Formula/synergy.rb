require 'formula'

class Synergy < Formula

  if ARGV.build_head?
    url 'http://synergy.googlecode.com/files/synergy-1.4.3-MacOSX106-Universal.zip'
    sha1 'aa60fa6ac975dd22dc095d6cd9f3dc755b91bb64'
    version '1.4.3'
  else
    url 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip'
    sha1 '5b9336fb553db17bd109e3f2bca517af18ed3863'
    version '1.3.6p2'
  end

  homepage 'http://synergy-foss.org'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
