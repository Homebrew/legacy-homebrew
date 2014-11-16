require "formula"

class Ninja < Formula
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.5.1.tar.gz"
  sha1 "c5a3af39f6d7ee3a30263f34091c046964d442f0"
  head "https://github.com/martine/ninja.git"

  def install
    system "python", "bootstrap.py"
    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end
end
