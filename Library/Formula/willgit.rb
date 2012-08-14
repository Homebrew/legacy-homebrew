require 'formula'

class Willgit < Formula
  homepage 'http://git-wt-commit.rubyforge.org/'
  head 'git://gitorious.org/willgit/mainline.git'

  def install
    prefix.install 'bin'
  end
end
