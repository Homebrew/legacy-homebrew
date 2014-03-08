require "formula"

class BrewWhich < Formula
  homepage "https://gist.github.com/g--n/9429311#file-brew-which"
  url "https://gist.github.com/9429311.git"
  version '1'

  def install

    bin.install "brew-which"
    ln_s bin/"brew-which", bin/"brew-exec"
  end
end
