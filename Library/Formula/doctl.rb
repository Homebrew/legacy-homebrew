require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.0.0.tar.gz"
  sha256 "62a5b539d07be25dae41a71f0b0d119e345eb3224a38f76bbef92aaa17ef0e66"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ed7db05132da3826632d4f4505f11352e3135e8f023a732aea888cb145bd56" => :el_capitan
    sha256 "4bfd2fbdcb0a8bfaf6613eefecd6736b8875ea152d0b1743af27c604b63c4b1e" => :yosemite
    sha256 "527289674fd9bbd887b43ed65a58e8089e40390d65a139a2c06f1909b342cda4" => :mavericks
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
