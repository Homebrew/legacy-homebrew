class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.2.0",
        :revision => "cbbae4c02e1b8e8420d3da767efdc26fa120dec9"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "234dc9955c280a6c51429e09aa5174c1ebe1c68b3ddbc4bec6fce56fc0bb7631" => :el_capitan
    sha256 "8061ece663fd56944df7d1af4fc785d7cd5ba814b51abc13c6e8096ee00f153e" => :yosemite
    sha256 "a7078edd6c286b8109b3b7d6047ae2503374b7dde9c1140d3d19aa815e0cf07b" => :mavericks
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
