require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.2.2.zip'
  homepage 'http://www.playframework.org/'
  md5 'd50f34bacf02f1ebb90eb13920b14346'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
