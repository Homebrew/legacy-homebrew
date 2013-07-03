require 'formula'

class Sl < Formula
  homepage 'http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html'
  #version 5.00, the author has not tagged the commit
  url 'https://github.com/mtoyoda/sl/archive/d8f076a7ddb1f6ef9b2033497707867e29569750.tar.gz'
  sha1 '6314807a299ca9b1666522cba23a3fba6df60fab'
  version '5.00'

  fails_with :clang do
    build 318
  end

  def install
    system "make -e"
    bin.install "sl"
    man1.install "sl.1"
  end
end
