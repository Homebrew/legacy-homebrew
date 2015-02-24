require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r1217/trunk/src/winetricks', :using => :curl
  # since the version stated in the field is seldom updated, we append the revision number
  version '20141125-r1217'
  sha256 'b2317fbac4282412cc7f6d8f1d387da73dac6d4f5580a8ef8d8f2a2ae8df34b8'

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
