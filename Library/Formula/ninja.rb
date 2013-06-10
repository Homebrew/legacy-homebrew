require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/archive/v1.3.3.tar.gz'
  sha1 '1e27d85316a267afa5e98ed62b660395ab5b9851'

  depends_on :python

  def install
    system python, "./bootstrap.py"
    bin.install "ninja"
    bash_completion.install 'misc/bash-completion' => 'ninja-completion.sh'
  end
end
