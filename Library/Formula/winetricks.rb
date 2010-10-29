require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://www.kegel.com/wine/winetricks', :using => :curl
  homepage 'http://wiki.winehq.org/winetricks'
  version '20101008'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks', :using => :curl

  if ARGV.build_head?
    md5 'c42ee409c7c4b71dfd4ee326aab8e14c'
  else
    md5 '2953c076ab699a659d06a4790a2ab602'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
