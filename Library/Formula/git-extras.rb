require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/0.7.0'
  sha1 '03fd10ad4b1b3786912a77bdb32c30973507dc6a'
  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    bin.mkpath
    system "make", "install"
  end
end
