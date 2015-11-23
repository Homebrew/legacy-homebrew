class CsvFix < Formula
  desc "CSVfix is a tool for manipulating CSV data"
  homepage "http://neilb.bitbucket.org/csvfix/"
  url "https://bitbucket.org/neilb/csvfix/get/version-1.6.tar.gz"
  sha256 "32982aa0daa933140e1ea5a667fb71d8adc731cc96068de3a8e83815be62c52b"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "make", "lin"
    bin.install "csvfix/bin/csvfix"
  end

  test do
    assert_equal %("foo","bar"
),
                 pipe_output("#{bin}/csvfix trim", "foo , bar \n")
  end
end
