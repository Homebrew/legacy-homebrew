class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.2.1",
        :revision => "6cb596b5066d47074df5c071925bcf559282d3b5"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3195137f3235383309c7a0843c289adc9bafb86cf9a6470a70e27bd7df268081" => :el_capitan
    sha256 "e6cb300ba3939a469c48d88fee62c7c687d6c6607958b396823efac32b6aa278" => :yosemite
    sha256 "621d48af23f4cf41e137f12e8044dac6766465076b775636de03e1588151303f" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "carina", "VERSION=#{version}"
      bin.install "carina"
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
