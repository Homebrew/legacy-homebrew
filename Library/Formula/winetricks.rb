require 'formula'

class Winetricks < ScriptFileFormula
  url 'http://winezeug.googlecode.com/svn-history/r969/trunk/winetricks'
  version 'r969'
  md5 '1b8187bd3735cf36e486a28526650d4a'

  head 'http://winezeug.googlecode.com/svn/trunk/winetricks'

  homepage 'http://wiki.winehq.org/winetricks'
  
  # depends_on 'wine' # Don't actually force Wine to install first!

  def download_strategy
    CurlDownloadStrategy
  end
end
