class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7039.tar.gz"
  sha256 "b3326c363a1b100008596e21cd3be182f712f1a2b9cb5d608e463ac3111dcc9c"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
