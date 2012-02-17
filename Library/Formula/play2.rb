require 'formula'

class Play2 < Formula
  homepage 'http://www.playframework.org/2.0'
  url 'http://download.playframework.org/releases/play-2.0-RC2.zip'
  md5 '8319bdefbad86c9f58d71b24c029a668'

  def install
    rm Dir['play.bat'] # remove windows command file
    libexec.install Dir['*']
    bin.install_symlink libexec+'play'
  end
end