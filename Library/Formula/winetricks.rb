require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://www.kegel.com/wine/winetricks',
        :using => :curl
  version '20100917'
  md5 '2953c076ab699a659d06a4790a2ab602'
  homepage 'http://wiki.winehq.org/winetricks'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks',
        :using => :curl

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
