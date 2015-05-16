require "language/go"

class Vegeta < Formula
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.6.3.tar.gz"
  sha1 "f20a34040319724e9bb9a1ad630f9eb1f4231073"

  bottle do
    cellar :any
    sha256 "d4a3eabe14e2bd901f6e11429343cc759db9e527adf22f03ce20e7ca6cbd9148" => :yosemite
    sha256 "2005307d4b6a4c98ff564225692cae26c70f0f68d72ad6321ae6bb646b4bdb94" => :mavericks
    sha256 "8b54aff2e4b930ea3253ed5022a028e0a4af64d34a75a5a26b4b9128cbe0ba39" => :mountain_lion
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
    ENV["CGO_ENABLED"] = "0"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version v5.6.3", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    pipe_output("#{bin}/vegeta attack -duration=1s -rate=1 | #{bin}/vegeta report", "GET http://localhost/")
  end
end
