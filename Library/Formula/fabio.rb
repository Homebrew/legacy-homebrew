require "language/go"

class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router."
  homepage "https://github.com/eBay/fabio"
  url "https://github.com/eBay/fabio/archive/v1.0.8.tar.gz"
  sha256 "32f771087cbd789293b655d7469e9a79d4f16c65956f81d54be8ff0fcf2d6e39"

  head "https://github.com/eBay/fabio.git"

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/ebay"
    ln_s buildpath, buildpath/"src/github.com/ebay/fabio"

    ENV["GOPATH"] = "#{buildpath}/_third_party:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "fabio"
    bin.install "fabio"
  end

  test do
    output = shell_output("#{bin}/fabio -v")
    assert_match version.to_s, output
  end
end
