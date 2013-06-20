require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/archive/v1.3.4.tar.gz'
  sha1 'e6ac7d49b2b5913956ad6740c8612981183808af'

  depends_on :python

  def install
    system python, "./bootstrap.py"
    bin.install "ninja"
    bash_completion.install 'misc/bash-completion' => 'ninja-completion.sh'
  end
end
