require "formula"

class Selecta < Formula
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.3.tar.gz"
  sha1 "0530f2145d5eb018ba9cf7108bd78d3e5bb03434"

  def install
    bin.install "selecta"
  end

  test do
    system "#{bin}/selecta", "--version"
  end

  def caveats; <<-EOS.undent
    Selecta requires Ruby 1.9 or better.
    EOS
  end
end
