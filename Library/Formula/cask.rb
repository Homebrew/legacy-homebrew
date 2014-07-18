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
  url "https://github.com/cask/cask/archive/v0.7.0.tar.gz"
  sha1 "0f84c4a824bf93c0f1b207b21db820dbb4d41599"
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
