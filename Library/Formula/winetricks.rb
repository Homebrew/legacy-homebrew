require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r832/trunk/src/winetricks', :using => :curl
  version '20120308-r832'
  # since the version stated in the field is seldom updated, we append the revision number

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide a hash for the HEAD build
  unless ARGV.build_head?
    sha256 '3ca2eb2afb09d895a3689cce24b78e76254f86c7b60b3cb582dc14fd89212e97'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
