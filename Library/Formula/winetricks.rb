require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r781/trunk/src/winetricks', :using => :curl
  version '20111115'
  # this is the version stated in the file, but note that it is not always updated

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide an md5 for the HEAD build
  unless ARGV.build_head?
    sha256 '83614fe242671da7e44adac52dc94c8272dd253b37d404417696a90862a40d53'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
