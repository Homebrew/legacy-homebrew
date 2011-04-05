require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'git://github.com/visionmedia/git-extras.git', :tag => '0.4.0'
  version '0.4.0'
  head 'git://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
