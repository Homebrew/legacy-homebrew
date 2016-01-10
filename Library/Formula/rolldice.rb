class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/1.15.tar.gz"
  sha256 "3abeec2b5b80ff57b05a3b2c1d49dade443005f1718f353873f54c0053610764"

  bottle do
    cellar :any_skip_relocation
    sha256 "b15c8dd417d710a734f2b445083752dd072b6d1cb39260901dcbd9634820fe8d" => :el_capitan
    sha256 "4e818eaba72271765a7c50c97a60764c37e0a1c6d4308e4490dbe811b32ff8ba" => :yosemite
    sha256 "4974aa7720ba08112cfd0eecc2611a82eb8fc9ac379fe779ba98f5e1509255e6" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    assert_match "Roll #1", shell_output("#{bin}/rolldice -s 1x2d6")
  end
end
