require 'formula'

class Lolcode < Formula
  homepage 'http://lolcode.org'
  head 'https://github.com/justinmeza/lolcode.git'
  url 'https://github.com/justinmeza/lci/archive/v0.11.1.tar.gz'
  sha1 '9949a2480a738ac566dbe66142dd351f778fb8b7'

  depends_on 'cmake' => :build

  conflicts_with 'lci', :because => 'both install `lci` binaries'

  def install
    system "cmake ."
    system "make"
    # Don't use `make install` for this one file
    bin.install 'lci'
  end
end
