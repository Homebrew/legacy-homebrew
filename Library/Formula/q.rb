class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.5.0.tar.gz"
  sha256 "69bde3fb75aa1d42ba306576b135b8a72121a995e6d865cc8c18db289c602c4b"

  head "https://github.com/harelba/q.git"

  bottle do
    cellar :any
    sha256 "8bb1bea3312d72d0a1cb68979d332cec65b28a0f9ef50de5e2ef570a27b2b155" => :yosemite
    sha256 "f056589aa258aeb832938996d7b80bb6648195d1a7c8bbeb1316bbe46ecdc1c0" => :mavericks
    sha256 "0b30c68a74242e9b82cf2d2dfa05bfadfa5ffa47916a17cd7baf1e6ed13b1d80" => :mountain_lion
  end

  def install
    bin.install "bin/q"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end

