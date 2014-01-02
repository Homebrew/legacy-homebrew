require 'formula'

class Pngpaste < Formula
  homepage 'https://github.com/jcsalterego/pngpaste'
  url 'https://github.com/jcsalterego/pngpaste/archive/1.0.1.tar.gz'
  sha1 'f81bf4a8bbda7fc1fde7a8bbb039fb1e25c4aee5'

  def install
    system 'make', 'all'
    bin.install 'pngpaste'
  end
end
