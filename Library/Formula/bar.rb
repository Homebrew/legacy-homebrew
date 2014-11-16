require 'formula'

class Bar < Formula
  homepage 'http://www.theiling.de/projects/bar.html'
  url 'http://www.theiling.de/downloads/bar-1.4-src.tar.bz2'
  sha1 '00b55ca1d52ca6ed099937692697c2257833c73c'

  def install
    bin.install 'bar'
  end
end
