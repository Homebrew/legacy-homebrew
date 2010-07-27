require 'formula'

class Play <Formula
  url 'http://download.playframework.org/releases/play-1.0.3.1.zip'
  homepage 'http://www.playframework.org/'
  md5 'b704cef8f2d8a68088ed0f80a4c4abe9'

  def install
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
