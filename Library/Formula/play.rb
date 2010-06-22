require 'formula'

class Play <Formula
  url 'http://download.playframework.org/releases/play-1.0.3.zip'
  homepage 'http://www.playframework.org/'
  md5 '25d3197c83cc60bde9281d519fae0735'

  def install
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end
