require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.0.0.tar.gz"
  sha256 "62a5b539d07be25dae41a71f0b0d119e345eb3224a38f76bbef92aaa17ef0e66"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c7f115393c78e32d2073843330e3ab199e721c58d7f322aa9f9dd49dcaade82a" => :el_capitan
    sha256 "2e7fe1da197114a7e3398c21a39e6731396233e9c45bb5526bf0bdf63d0ae15e" => :yosemite
    sha256 "e4dd84c4b011dea5f9e0872f95eaaa5491543bc47e0db0fd35a294dd81cb5f39" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X github.com/digitalocean/doctl/Build=#{version}", "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"
  end

  test do
    system bin/"doctl", "help"
  end
end
