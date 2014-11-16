require "formula"

class Q < Formula
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.4.0.tar.gz"
  sha1 "e8efe87aa691a7ab57e95f15cf4b2babfbabe945"

  def install
    bin.install "bin/q"
  end

  test do
    output = shell_output("seq 1 100 | #{bin}/q 'select sum(c1) from -'")
    assert_equal "5050\n", output
  end
end

