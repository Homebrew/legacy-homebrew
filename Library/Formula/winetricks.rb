require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r1187/trunk/src/winetricks', :using => :curl
  # since the version stated in the field is seldom updated, we append the revision number
  version '20140415-r1187'
  sha256 '8284dab0574ae68a0351d924a603f4c96d1b726dd05007172313d1855088b1d0'

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
