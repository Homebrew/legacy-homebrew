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
    require 'open3'
    Open3.popen3("#{bin}/jshon", "-l") do |stdin, stdout, _|
      stdin.write("[true,false,null]")
      stdin.close
      assert_equal "3", stdout.read.strip
    end
  end
end
