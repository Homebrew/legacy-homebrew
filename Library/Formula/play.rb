require 'formula'

class Play <Formula
  url 'http://download.playframework.org/releases/play-1.1RC3.zip'
  homepage 'http://www.playframework.org/'
  md5 '7fbbac33ac0ab72edb69bb14255f4bba'

  def install
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
