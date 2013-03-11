require 'formula'

class Cpulimit < Formula
  homepage 'http://cpulimit.sourceforge.net/'
  url 'https://github.com/opsengine/cpulimit/archive/v0.1.tar.gz'
  sha1 'b7c16821a3e04698b79b28905b68b8c518417466'

  head 'https://github.com/opsengine/cpulimit.git'

  def install
    system 'make'
    bin.install 'src/cpulimit'
  end

  test do
    system *%W{#{bin}/cpulimit -l 10 ls}
  end
end
