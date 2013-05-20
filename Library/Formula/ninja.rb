require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/archive/v1.3.2.tar.gz'
  sha1 'c91b0df9bd4d3700695e77c31baaef74f6496152'

  def install
    system "./bootstrap.py"
    bin.install "ninja"
    bash_completion.install 'misc/bash-completion' => 'ninja-completion.sh'
  end
end
