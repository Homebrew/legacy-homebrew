require 'formula'

class GitExtras <Formula
  url 'git://github.com/visionmedia/git-extras.git', :tag => '0.0.5'
  version '0.0.5'
  head 'git://github.com/visionmedia/git-extras.git', :branch => 'master'

  homepage 'http://github.com/visionmedia/git-extras'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
