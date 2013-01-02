require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://www.lightandmatter.com/when/when.tar.gz'
  sha1 'fba571196d347bb3017af3551fe5e0920a54ef8e'
  version '1.1.29'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
