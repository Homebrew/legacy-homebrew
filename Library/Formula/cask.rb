require "formula"

class NewEnoughEmacs < Requirement
  fatal true
  default_formula "emacs"

  def satisfied?
    major_version = `emacs --batch --eval "(princ emacs-major-version)"`.to_i
    major_version >= 23
  end

  def message
    "Emacs 23 or later is required to run cask."
  end
end

class Cask < Formula
  homepage "http://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.2.tar.gz"
  sha1 "2c8012487f06c6b4f47ce56bd021bb71753f1bd0"
  head "https://github.com/cask/cask.git"

  depends_on NewEnoughEmacs

  def install
    zsh_completion.install "etc/cask_completion.zsh"
    bin.install "bin/cask"
    prefix.install Dir["*.el"]
    prefix.install "templates"
    (share/"emacs/site-lisp").install_symlink "#{prefix}/cask-bootstrap.el"
    (share/"emacs/site-lisp").install_symlink "#{prefix}/cask.el"
    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end
end
