require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.1.1.zip'
  homepage 'http://www.playframework.org/'
  md5 '3a2a49cfcc0ea679c75d3c1cb34ec080'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
