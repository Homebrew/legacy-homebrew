require 'formula'

class F3 < Formula
  homepage 'http://oss.digirati.com.br/f3/'
  url 'https://github.com/AltraMayor/f3/tarball/v2.1'
  sha1 'c2b5d55e452a4d8c85649e198b028a7608ea6920'

  def install
    system "make mac"
    bin.install 'f3read', 'f3write'
  end
end
