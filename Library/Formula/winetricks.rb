require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://winezeug.googlecode.com/svn-history/r1987/trunk/winetricks', :using => :curl
  homepage 'http://wiki.winehq.org/winetricks'
  version '20101106'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide an md5 for the HEAD build
  unless ARGV.build_head?
    md5 '5a6986df670e093381ee007f0c0c0e1f'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
