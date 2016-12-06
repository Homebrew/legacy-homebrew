require 'formula'

class LighttablePlayground < Formula
  homepage 'http://www.chris-granger.com/2012/06/24/its-playtime/'
  url 'http://temp2.kodowa.com/playground/light'
  md5 '79eeb8c055ed3bf227913ff8961ede26'
  version '1.0'

  def install
    bin.install "light"
  end
end
