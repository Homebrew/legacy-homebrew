class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7040.tar.gz"
  sha256 "48a747c040689445f7db0edd169da0abd709a37cfece3ceecff0816c09beab0e"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
