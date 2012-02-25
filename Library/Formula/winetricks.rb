require 'formula'

class Winetricks < ScriptFileFormula
  homepage 'http://code.google.com/p/winetricks/'
  url 'http://winetricks.googlecode.com/svn-history/r795/trunk/src/winetricks', :using => :curl
  version '20120308'
  # this is the version stated in the file, but note that it is not always updated

  head 'http://winetricks.googlecode.com/svn/trunk/src/winetricks', :using => :curl

  depends_on 'cabextract'

  # Don't provide an md5 for the HEAD build
  unless ARGV.build_head?
    sha256 'c6df4d7a8c0d4218507edd12607cec677378d6cf7371324d9cd4a07c923e1bae'
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
