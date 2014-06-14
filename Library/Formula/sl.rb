require 'formula'

class Sl < Formula
  homepage 'https://github.com/mtoyoda/sl'
  url 'https://github.com/mtoyoda/sl/archive/5.01.tar.gz'
  sha256 'b16fcaa40cb195105e97f86280e3f37a9011d0c01d7e534946386d126408f6da'

  head 'https://github.com/mtoyoda/sl.git'

  fails_with :clang do
    build 318
  end

  def install
    system "make -e"
    bin.install "sl"
    man1.install "sl.1"
  end
end
