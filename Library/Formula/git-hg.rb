require 'formula'

class HgInstalled < Requirement
  def message; <<-EOS.undent
    Mercurial is required to use this software.

    You can install this with Homebrew using:
      brew install mercurial

    Or you can use an official installer from:
      http://mercurial.selenic.com/
    EOS
  end
  def satisfied?
    which 'hg'
  end
end

class GitHg < Formula
  head 'https://github.com/offbytwo/git-hg.git'
  homepage 'http://offbytwo.com/git-hg/'

  depends_on HgInstalled.new

  def install
    prefix.install Dir['*']
  end
end
