class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v6.0.tar.gz"
  sha256 "d72addb15809bc6229a08ac57e2b87b34eac80346384560ba1f16dae03fbebd5"

  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b3eb529dd5ed455ecc8c1420c9fa1011ca84fc841fdb1570b5651ce171b988f" => :el_capitan
    sha256 "ea3c848931257bbeb60e85a672d7132556528646bd2b1f5e35ace60461b80a34" => :yosemite
    sha256 "96ee5681212139b960fdaca98839e2e5e23446f1b890b751c459b05bedabaf6a" => :mavericks
  end

  def install
    system "make", "all"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
