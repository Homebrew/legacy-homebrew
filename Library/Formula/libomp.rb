require "formula"

class Libomp < Formula
  homepage "https://www.openmprtl.org/download"
  url "https://www.openmprtl.org/sites/default/files/libomp_20140926_oss.tgz"
  sha1 "488ff3874eb5c971523534cb3c987bfb5ce3addb"

  depends_on :arch => :x86_64

  def install
    system "make", "compiler=clang"
    include.install Dir["exports/common/include/*"]
    lib.install "exports/mac_32e/lib.thin/libiomp5.dylib"
  end
end
