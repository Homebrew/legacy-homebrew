class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.2.0",
        :revision => "cbbae4c02e1b8e8420d3da767efdc26fa120dec9"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e98fd8af080d943d75b67f4c92739e526d681df37a798c7cb3905712aefbafb9" => :el_capitan
    sha256 "ff35c1a1fe7a77bc5cbb4485d452b3926b3e9191a2c965be42cfa55d1e0242c5" => :yosemite
    sha256 "e1ff26408166ebfbbe5df3d1efd1e51e31d297829fbd4bb768c2eb2f3e4aeeca" => :mavericks
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
