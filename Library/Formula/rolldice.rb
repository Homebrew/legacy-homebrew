class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/v1.14.tar.gz"
  sha256 "57b77e9d2f8d04c7d81fa01433a73f1f86b4b21771f959acc3bb5d99347030eb"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    output = `#{bin}/rolldice -s 1x2d6`
    assert output.include?("Roll #1")
    assert_equal 0, $?.exitstatus
  end
end
