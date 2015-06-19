class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7031.tar.gz"
  sha256 "7ff36a42aa46146cbe423f4dd4f2c0d8bd57c0e9968cf05651fac0f47ac82e98"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "-V"
  end
end
