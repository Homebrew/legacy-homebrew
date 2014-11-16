require 'formula'

class Jshon < Formula
  homepage 'http://kmkeen.com/jshon/'
  url 'http://kmkeen.com/jshon/jshon.tar.gz'
  version '8'
  sha1 'e8d710f621ed42ab126c921f87bc8906af16cd1d'

  depends_on 'jansson'

  def install
    system 'make'
    bin.install 'jshon'
    man1.install 'jshon.1'
  end

  test do
    assert_equal "3", pipe_output("#{bin}/jshon -l", "[true,false,null]").strip
  end
end
