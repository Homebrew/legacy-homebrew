class Selecta < Formula
  desc "Fuzzy text selector for files and anything else you need to select"
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.6.tar.gz"
  sha256 "c5e0fdab53b3c4942e46c1a2c5a38158f21eb0520c6391f77d6d0a7d2a023318"

  bottle :unneeded

  depends_on :ruby => "1.9"

  def install
    bin.install "selecta"
  end

  test do
    system "#{bin}/selecta", "--version"
  end
end
