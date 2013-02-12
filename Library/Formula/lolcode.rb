require 'formula'

class Lolcode < Formula
  homepage 'http://www.icanhaslolcode.org/'
  url 'https://github.com/justinmeza/lci/tarball/v0.10.3'
  sha1 'c3e4b2b0b83a5e257c2e0e3b613c83c3cae4d084'

  head 'https://github.com/justinmeza/lolcode.git'

  depends_on 'cmake' => :build

  def install
    system "cmake ."
    system "make"
    # Don't use `make install` for this one file
    bin.install 'lci'
  end
end
