require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r610/trunk/src/winetricks', :using => :curl
  version '20110429'

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide an md5 for the HEAD build
  unless ARGV.build_head?
    sha256 '5f7d627dad0a5e43f1dd3ea7b3bd2d5c786490976c47a5d14efe2af4d449a041'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
