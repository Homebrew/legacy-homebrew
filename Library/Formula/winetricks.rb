require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r798/trunk/src/winetricks', :using => :curl
  version '20120308-r798'
  # since the version stated in the field is seldom updated, we append the revision number

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide an md5 for the HEAD build
  unless ARGV.build_head?
    sha256 'cc71fbe6ada29a76693694a232cc4df49a9183f76d3e20eaf8123f94814d0126'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
