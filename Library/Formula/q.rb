require "formula"

class Q < Formula
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.5.0.tar.gz"
  sha1 "772c1bc7a49d725042ffc130e3c9328fc9da67dc"

  def install
    bin.install "bin/q"
  end

  test do
    output = shell_output("seq 1 100 | #{bin}/q 'select sum(c1) from -'")
    assert_equal "5050\n", output
  end
end

