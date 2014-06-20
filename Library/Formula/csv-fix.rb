require "formula"

class CsvFix < Formula
  homepage "http://code.google.com/p/csvfix/"
  url "https://bitbucket.org/neilb/csvfix/get/version-1.6.tar.gz"
  sha1 "ca770b47f2e08a09350c4005e6ab3c524798b440"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "make lin"
    bin.install "csvfix/bin/csvfix"
  end

  test do
    IO.popen("#{bin}/csvfix trim", "w+") do |pipe|
      pipe.write "foo , bar \n"
      pipe.close_write
      assert_equal %{"foo","bar"\n}, pipe.read
    end
  end
end
