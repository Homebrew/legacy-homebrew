require 'formula'

class Lolcode < Formula
  homepage 'http://www.icanhaslolcode.org/'
  url 'https://github.com/justinmeza/lci/archive/v0.10.3.tar.gz'
  sha1 '05f08be0e2eecc6e774b656e614bd48ef12481a7'

  head 'https://github.com/justinmeza/lolcode.git'

  depends_on 'cmake' => :build

  def install
    system "cmake ."
    system "make"
    # Don't use `make install` for this one file
    bin.install 'lci'
  end
end
