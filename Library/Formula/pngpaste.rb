require 'formula'

class Pngpaste < Formula
  homepage 'https://github.com/jcsalterego/pngpaste/'
  url 'https://github.com/jcsalterego/pngpaste/tarball/master'
  sha1 'd498e964cce02c6f3e7389a14139078f2819d6b9'
  version '1.0.0'

  def install
    system 'make', 'all'
    
    bin.install 'pngpaste'
  end
end
