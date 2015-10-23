class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.5.0.tar.gz"
  sha256 "69bde3fb75aa1d42ba306576b135b8a72121a995e6d865cc8c18db289c602c4b"
  head "https://github.com/harelba/q.git"

  bottle :unneeded

  def install
    bin.install "bin/q"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
