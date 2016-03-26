class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/1.8.tar.gz"
  sha256 "352c95f0ba69864dce37a9010e91fa227b37a072922107ec84246f3c760fa4cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "476c5ddac08de85fbc2a4fb743f32e413819cec17cc92dd4b89e28d552637fd1" => :el_capitan
    sha256 "264855d481da6f9a92bc96174fe7881cc5863039e6c111892ce03cbb0415126e" => :yosemite
    sha256 "1adec475e32c12bd106a2f30e5b4b7925536c9105b3289562cb9c10419df2e5d" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/buku", "-a", "https://github.com/Homebrew/homebrew"
    assert_match %r{https://github.com/Homebrew/homebrew}, shell_output("#{bin}/buku -s github </dev/null")
  end
end
