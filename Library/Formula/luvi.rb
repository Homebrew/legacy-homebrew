class Luvi < Formula
  desc "A project in-between luv and luvit, lua packages."
  homepage "https://github.com/luvit/luvi"
  url "https://github.com/luvit/luvi/releases/download/v2.1.8/luvi-src-v2.1.8.tar.gz"
  sha256 "1ef449c6a76bcf7a03c8bbcdd5423b0366d63b10c52fd463ca2ba8aaf9248781"

  depends_on "cmake" => :build

  def install
    system "make", "regular-asm"
    system "make"
    bin.install "build/luvi"
  end

  test do
    system "#{bin}/luvi", "samples/test.app", "--", "1", "2", "3", "4"
  end
end

