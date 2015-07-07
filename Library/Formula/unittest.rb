class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "http://unittest.red-bean.com/"
  url "http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha1 "c9012061963ac1330c6c6efc8cdbbb79360757fe"

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
