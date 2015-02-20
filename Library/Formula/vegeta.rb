require "language/go"

class Vegeta < Formula
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.5.2.tar.gz"
  sha1 "a0b2d4c4bca0023a8407a819f64c3f96e1ebe3bc"

  bottle do
    cellar :any
    sha1 "67f9935eab0712fdabae55b9a091cbbc5bd2b81c" => :yosemite
    sha1 "81f64990ddb69035ebbcb16c33db0f62fdd5dd66" => :mavericks
    sha1 "b0a7521f7b0b858782fd817ba24460cea55c2d80" => :mountain_lion
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
