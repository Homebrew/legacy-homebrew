require 'formula'

class Play <Formula
  url 'http://download.playframework.org/releases/play-1.1.zip'
  homepage 'http://www.playframework.org/'
  md5 '54513b11dc4eacd68d01f5c59bb8ec97'

  def install
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
