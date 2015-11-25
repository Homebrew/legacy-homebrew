class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v0.9.1",
        :revision => "cb63dc0873b69bb774cea606a001eb355b372eb2"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1fe7d2623aa0a6395bd62bad74c34abc53b662ff80058f1fdcfdfa5d73bcc46" => :el_capitan
    sha256 "6550386610e91c0203b2f987733948ba00c28356d275091e6a32d6a95e753430" => :yosemite
    sha256 "9989739a3b9c1092b7e28a9625e6db27855ca9970e08b7a203844dd88dae560d" => :mavericks
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
