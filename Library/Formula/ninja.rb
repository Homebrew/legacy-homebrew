require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/archive/v1.4.0.tar.gz'
  sha1 '3ab2fcb71e9f70c19cda2d63983cdfe0f971d04f'
  head 'https://github.com/martine/ninja.git'

  depends_on :python

  def install
    system python, "./bootstrap.py"
    bin.install "ninja"
    bash_completion.install 'misc/bash-completion' => 'ninja-completion.sh'
  end
end
