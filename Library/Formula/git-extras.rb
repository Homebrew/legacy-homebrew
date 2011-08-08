require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/0.6.0'
  sha1 '7e96df0793c0d1370bf2b0fb809c91317f92240b'
  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
