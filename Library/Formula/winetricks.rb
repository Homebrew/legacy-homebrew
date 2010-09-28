require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://www.kegel.com/wine/winetricks',
        :using => :curl
  version '20100917'
  md5 'f5823c765572a90df2b52b476915cd59'
  homepage 'http://wiki.winehq.org/winetricks'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks',
        :using => :curl

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
