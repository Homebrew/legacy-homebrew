require 'formula'

class Lolcode < Formula
  homepage 'http://www.icanhaslolcode.org/'
  url 'https://github.com/justinmeza/lci/tarball/v0.9.3'
  sha1 '212c5a4f414063a1b994a9a4446dc8da69577dd4'

  head 'https://github.com/justinmeza/lolcode.git'

  depends_on 'cmake' => :build

  def install
    system "cmake ."
    system "make"
    # Don't use `make install` for this one file
    bin.install 'lci'
  end
end
