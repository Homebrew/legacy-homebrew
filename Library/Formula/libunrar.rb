class Libunrar < Formula
  homepage "http://rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.2.6.tar.gz"
  sha1 "bdd4c8936fd0deb460afe8b7afa9322dd63f3ecb"

  def install
    system "make", "-f", "makefile", "lib"
    mv "./libunrar.so", "./libunrar.dylib"
    lib.install "libunrar.dylib"
  end

end
