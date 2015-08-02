require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.7.1.tar.gz"
  sha1 "2d10d66460fdd7bd6a4e0cabc50d519dd72244bd"

  bottle do
    cellar :any
    sha256 "ef0965454eb37a26a2113647d4214e14d38d8f3e89f26de2da2471972e8962a9" => :yosemite
    sha256 "46b4b7560d65c47deb00bedc5b6f2e80549074bc0b9c0d639ca7cac1e83e22c3" => :mavericks
    sha256 "8cfd06e0427cacb68bb65357fab9bf95375748b7b8c7a64fcb21076701b6ce5f" => :mountain_lion
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

    system "go", "build", "-ldflags", "-X main.Version v5.7.1", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    pipe_output("#{bin}/vegeta attack -duration=1s -rate=1 | #{bin}/vegeta report", "GET http://localhost/")
  end
end
