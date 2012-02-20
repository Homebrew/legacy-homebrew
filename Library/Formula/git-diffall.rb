require 'formula'

class GitDiffall < Formula
  homepage 'https://github.com/thenigan/git-diffall'
  url 'https://github.com/thenigan/git-diffall/tarball/v1.0.0'
  md5 '2a65d879bc4980908d64dcad4a674886'

  head 'https://github.com/thenigan/git-diffall.git'

  def install
    bin.install 'git-diffall'
  end
end
