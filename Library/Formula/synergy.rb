require 'formula'

class Synergy < Formula

  if ARGV.build_head?
    url 'http://synergy.googlecode.com/files/synergy-1.4.3-MacOSX106-Universal.zip'
    sha1 'aa60fa6ac975dd22dc095d6cd9f3dc755b91bb64'
    version '1.4.3'
  else
    url 'http://synergy.googlecode.com/files/synergy-1.3.7-MacOSX106-Universal.zip'
    sha1 'f0380e9b810752045f76340767ab0e7a5dcde698'
    version '1.3.7'
  end

  homepage 'http://synergy-foss.org'

  def install
    bin.install 'synergyc'
    bin.install 'synergys'
  end
end
