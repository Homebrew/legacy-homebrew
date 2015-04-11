class Selecta < Formula
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.6.tar.gz"
  sha1 "bf8881b2d545847921b1a05d23b88e2037c358e4"

  depends_on :ruby => "1.9"

  def install
    bin.install "selecta"
  end

  test do
    system "#{bin}/selecta", "--version"
  end
end
