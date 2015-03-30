require "language/go"

class Vegeta < Formula
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.6.1.tar.gz"
  sha1 "9b1455423c0b87fcf6e3ea65b3e6ba89c687700d"

  bottle do
    cellar :any
    sha256 "2f1c99d31c3180395d1303fe86e731e11b72b86bc5ead5230e60ef8976f9e0d5" => :yosemite
    sha256 "05030e85e6aad70e4b995fb69c43502ee910d4031a91d6a7593d5816605f435a" => :mavericks
    sha256 "ceab3a9212a6e1175e0b0221233cf13ee55b6ffadde0e3605ed858208f86548b" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  def install
    mkdir_p buildpath/"src/github.com/tsenart/"
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
  end
end
