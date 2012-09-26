require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/tarball/v1.0.0'
  sha1 '10995610f7235dcaadc55c9ecf3fee31a5a6e856'

  def install
    system "./bootstrap.py"
    bin.install "ninja"
    mv 'misc/bash-completion', 'misc/ninja-completion.sh'
    (prefix+'etc/bash_completion.d').install 'misc/ninja-completion.sh'
  end
end
