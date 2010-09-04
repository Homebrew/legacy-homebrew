require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://winezeug.googlecode.com/svn-history/r1019/trunk/winetricks',
        :using => :curl
  version '20100316'
  md5 '79ab153ae51289ec7c25c7b7ed5d68ff'
  homepage 'http://wiki.winehq.org/winetricks'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks',
        :using => :curl

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
