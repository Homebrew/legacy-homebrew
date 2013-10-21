require 'formula'

class Cask < Formula
  homepage 'http://cask.github.io/'
  url 'https://github.com/cask/cask/archive/v0.5.0.zip'
  sha1 'b73b5f253af2aabc37fa63fcf1bb39406bf5ced7'
  head 'https://github.com/cask/cask.git'

  def install
    zsh_completion.install 'etc/cask_completion.zsh'
    bin.install 'bin/cask'
    prefix.install 'Cask'
    prefix.install Dir['*.el']
    prefix.install 'templates'
  end

  def test
    system "make server"
    system "make"
  end
end
