require 'formula'

class GitUtils < Formula
  head 'https://github.com/ddollar/git-utils.git'
  homepage 'https://github.com/ddollar/git-utils'

  def install
    bin.install Dir['git-*']
  end
end
