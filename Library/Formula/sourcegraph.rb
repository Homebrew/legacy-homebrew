class Sourcegraph < Formula
  desc "Smarter code host powering top-tier development teams"
  homepage "https://www.sourcegraph.com"
  url "https://sourcegraph.com/.download/0.11.2/darwin-amd64/src.gz"
  sha256 "452d2c1710efeb3c42160280c14e261c14c2de903f49cacd0d2e4bb426c48b8a"

  def install
    bin.install "src"
  end

  test do
    `system "#{bin}/src" "help"`
  end
end
