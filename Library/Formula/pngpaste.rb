require 'formula'

class Pngpaste < Formula
  homepage 'https://github.com/jcsalterego/pngpaste'
  url 'https://github.com/jcsalterego/pngpaste/tarball/1.0.1'
  sha1 '473af09e6d4ea0d72c4f5478780a03452cea90c5'

  def install
    system 'make', 'all'
    bin.install 'pngpaste'
  end
end
