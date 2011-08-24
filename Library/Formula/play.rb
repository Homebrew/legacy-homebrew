require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.2.3.zip'
  homepage 'http://www.playframework.org/'
  md5 '75822b1ec443239a4467147a94882442'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
