require "formula"

class CsvFix < Formula
  homepage "http://neilb.bitbucket.org/csvfix/"
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
    assert_equal %{"foo","bar"\n},
                 pipe_output("#{bin}/csvfix trim", "foo , bar \n")
  end
end
