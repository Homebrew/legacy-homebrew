require 'formula'

class Jshon < Formula
  url 'http://kmkeen.com/jshon/jshon.tar.gz'
  homepage 'http://kmkeen.com/jshon/'
  sha1 'e8d710f621ed42ab126c921f87bc8906af16cd1d'
  version '8'

  depends_on 'jansson'

  def install
    system 'make'
    bin.install 'jshon'
    man1.install 'jshon.1'
  end

  def test
    system "echo '[true,false,null]'| #{bin}/jshon -l"
  end
end
