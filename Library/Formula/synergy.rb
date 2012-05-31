require 'formula'

class Synergy < Formula
  homepage 'http://synergy-foss.org'
  version '1.3.8'

  if MacOS.lion?
    url 'http://synergy.googlecode.com/files/synergy-1.3.8-MacOSX107-Universal.zip'
    sha1 '6b9b0e75a468b9f9c80519894e4d2d589aca2d31'
  else
    url 'http://synergy.googlecode.com/files/synergy-1.3.8-MacOSX106-Universal.zip'
    sha1 'cedf8dc0f5f1d95b967fabcd4ed9bfc0f72840e6'
  end

  devel do
    version '1.4.8'
    if MacOS.lion?
      url 'http://synergy.googlecode.com/files/synergy-1.4.8-MacOSX107-x86_64.dmg'
      sha1 '8c3f0326d74c935c20cc83c79dda20677d9b5814'
    elsif MacOS.snow_leopard?
      url 'http://synergy.googlecode.com/files/synergy-1.4.8-MacOSX106-i386.dmg'
      sha1 '1de78afdc838b1c0ef21e36d996b18ff6019b191'
    else
      opoo "No --devel for this version of OS X."
    end
  end

  def install
    bin.install 'synergyc', 'synergys'
  end
end
