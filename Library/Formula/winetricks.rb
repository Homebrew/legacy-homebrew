require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r1026/trunk/src/winetricks', :using => :curl
  # since the version stated in the field is seldom updated, we append the revision number
  version '20130629-r1026'
  sha256 'd0906097e6bd9b3f52715abb2e8d6ae70d20184d46ba004fa9f0bd537e786c1d'

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
