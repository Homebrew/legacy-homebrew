require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.0.0.tar.gz"
  sha256 "7933a77eaae1e5269f6490842527a646221d91515eb8e863e831df608e7a0d48"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa1dad859e7a526987077503af902edb4772da5aecb6f62ae26562a11b5f066c" => :el_capitan
    sha256 "0ee0bf6596ed1ae7f7b9fac7301ed55419e94b45b67ed471d7ae1e9cec635756" => :yosemite
    sha256 "ca72b348421fabb4604b85cbd9d4105c126789986d22a479cdba2be9e5323d0e" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
      :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  def install
    mkdir_p buildpath/"src/github.com/tsenart/"
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version=#{version}", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
    pipe_output("#{bin}/vegeta report", output)
  end
end
