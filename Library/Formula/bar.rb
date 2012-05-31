require 'formula'

class Bar < Formula
  url 'http://www.theiling.de/downloads/bar-1.4-src.tar.bz2'
  homepage 'http://www.theiling.de/projects/bar.html'
  md5 '4b99147e2efbe678cbcdc985ad2412f4'

  def install
    bin.install 'bar'
  end
end
