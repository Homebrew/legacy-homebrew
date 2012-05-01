require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://www.lightandmatter.com/when/when.tar.gz'
  md5 'e094bcff1e5a267094f14a50b673aab4'
  version '1.1.29'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
