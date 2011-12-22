require 'formula'

class Ezcomponents < Formula
  url 'http://ezcomponents.org/files/downloads/ezcomponents-2009.2.1-lite.tar.bz2'
  homepage 'http://ezcomponents.org'
  md5 '1f75f04942534d157df9121fadb33672'
  version '2009.2.1'

  def install
    (lib+'ezc').install Dir['*']
  end

  def caveats; <<-EOS.undent
    The eZ Components are installed in #{HOMEBREW_PREFIX}/lib/ezc
    Remember to update your php include_path if needed
    EOS
  end

end
