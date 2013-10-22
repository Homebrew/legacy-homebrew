require 'formula'

class NewEnoughEmacs < Requirement
  fatal true

  def satisfied?
    `emacs --version`.split("\n")[0] =~ /GNU Emacs (\d+)\./
    major_version = ($1 || 0).to_i
    major_version >= 23
  end

  def message
    "Emacs 23 or later is required to install cask."
  end

  default_formula "emacs"

end

class Cask < Formula
  homepage 'http://cask.github.io/'
  url 'https://github.com/cask/cask/archive/v0.5.0.zip'
  sha1 'b73b5f253af2aabc37fa63fcf1bb39406bf5ced7'
  head 'https://github.com/cask/cask.git'

  depends_on NewEnoughEmacs

  def install
    zsh_completion.install 'etc/cask_completion.zsh'
    bin.install 'bin/cask'
    prefix.install Dir['*.el']
    prefix.install 'templates'
  end

end
