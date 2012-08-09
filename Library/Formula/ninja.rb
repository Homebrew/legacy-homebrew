require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/tarball/release-120715'
  sha1 '623e7e86f05c76fe8ea8b5ce72f2a3a2a891ff38'

  def install
    system "./bootstrap.py"
    bin.install "ninja"
  end
end
