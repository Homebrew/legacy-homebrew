require "language/go"

class Vegeta < Formula
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.6.3.tar.gz"
  sha1 "f20a34040319724e9bb9a1ad630f9eb1f4231073"

  bottle do
    cellar :any
    sha256 "b7b3d8bdee9cf09db7ed21d4efd6af7551ab8814417eb73af47a1f28eccee8ec" => :yosemite
    sha256 "7728471232648de34d8ca376515268602a227c42f358e3317716d945734cdaaa" => :mavericks
    sha256 "ff254ccd57e84760fd2474d186cddf16f32074321469486eca4d8dfea5afe618" => :mountain_lion
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
