require 'formula'

class When < Formula
  url 'http://www.lightandmatter.com/when/when.tar.gz'
  homepage 'http://www.lightandmatter.com/when/when.html'
  md5 'f0abae65bbd53b07af7a29da8b817155'
  version '1.1.28'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
