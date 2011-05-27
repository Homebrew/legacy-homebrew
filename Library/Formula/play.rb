require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.2.1.zip'
  homepage 'http://www.playframework.org/'
  md5 '6974014f265b16e926e5dd5587573fea'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
