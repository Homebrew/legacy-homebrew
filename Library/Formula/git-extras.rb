require 'formula'

class GitExtras <Formula
  url 'git://github.com/visionmedia/git-extras.git', :tag => '0.0.7'
  version '0.0.7'
  head 'git://github.com/visionmedia/git-extras.git', :branch => 'master'

  homepage 'https://github.com/visionmedia/git-extras'

  # Patch won't be needed in 0.0.8. See:
  # https://github.com/visionmedia/git-extras/issues/issue/25
  def patches
    "https://github.com/visionmedia/git-extras/commit/88d3c87f8022ed6af9c268f09b505d8ba984501b.diff"
  end

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
