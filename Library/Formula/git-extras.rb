require 'formula'

class GitExtras < Formula
  url 'git://github.com/visionmedia/git-extras.git', :tag => '0.2.0'
  version '0.2.0'
  head 'git://github.com/visionmedia/git-extras.git', :branch => 'master'

  homepage 'https://github.com/visionmedia/git-extras'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
