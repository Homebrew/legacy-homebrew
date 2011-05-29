require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/0.5.1'
  sha1 'faaeb466154cff9021d19aa4cb4f080ac9ee6d9f'
  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
