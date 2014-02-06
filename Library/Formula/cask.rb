require 'formula'

class NewEnoughEmacs < Requirement
  fatal true

  def satisfied?
    major_version = `emacs --batch --eval '(princ emacs-major-version)'`.to_i
    major_version >= 23
  end

  def message
    "Emacs 23 or later is required to install cask."
  end

  default_formula "emacs"

end

class Cask < Formula
  homepage 'http://cask.github.io/'
  url 'https://github.com/cask/cask/archive/v0.5.2.zip'
  sha1 '0178e1b9a3ea80ad91e8a2d25ee3cdf7f782876f'
  head 'https://github.com/cask/cask.git'

  depends_on NewEnoughEmacs

  def install
    zsh_completion.install 'etc/cask_completion.zsh'
    bin.install 'bin/cask'
    prefix.install Dir['*.el']
    prefix.install 'templates'
    # Cask will refuse to upgrade in the presence of this file
    # Homebrew updates will therefore work more reliably
    touch prefix/".no-upgrade"
  end

end
