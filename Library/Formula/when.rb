require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://www.lightandmatter.com/when/when.tar.gz'
  sha1 '5f48fa1bc8cd700cf7d9d59f701db8b466b3e457'
  version '1.1.30'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
