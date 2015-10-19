class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/1.15.tar.gz"
  sha256 "3abeec2b5b80ff57b05a3b2c1d49dade443005f1718f353873f54c0053610764"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    output = `#{bin}/rolldice -s 1x2d6`
    assert_equal true, output.include?("Roll #1")
    assert_equal 0, $?.exitstatus
  end
end
