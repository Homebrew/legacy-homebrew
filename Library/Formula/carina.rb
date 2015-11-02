class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v0.9.0",
        :revision => "8e283d93f259cbc3c695cb22e18888603567a081"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a79c2155216ed381a75d80e1c5bff343d1c568b2a7bdb433902fb99c10b10680" => :el_capitan
    sha256 "7d0d8c3221259b5ad1c69f278db6e53d51ff2ac976fcf60e1df4e626d77e8814" => :yosemite
    sha256 "e756c8d3773b337634b9a00c31dec695fe1761c7604d7f813ee5f95bf5fbd625" => :mavericks
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
