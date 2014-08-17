require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r1199/trunk/src/winetricks', :using => :curl
  # since the version stated in the field is seldom updated, we append the revision number
  version '20140609-r1199'
  sha256 '25a039e7182797d77d9c8901220a2d30da36bbd6558ade3f7a82bf3b5ee02bc8'

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
