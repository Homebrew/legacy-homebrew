class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "http://unittest.red-bean.com/"
  url "http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
