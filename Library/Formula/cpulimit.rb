require 'formula'

class Cpulimit < Formula
  homepage 'http://cpulimit.sourceforge.net/'
  head 'https://github.com/opsengine/cpulimit.git'
  url 'https://github.com/opsengine/cpulimit/archive/v0.1.tar.gz'
  sha1 'b7c16821a3e04698b79b28905b68b8c518417466'

  def install
    system "make"
    bin.install 'src/cpulimit'
  end

  def test
    system "cpulimit -l 10 ls"
  end
end
