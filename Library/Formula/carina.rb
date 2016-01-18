class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.1.1",
        :revision => "247d3a1bcb9fc1e0c41317ea8d28fc5331d096ec"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c21f3544bb16d744d59db00a4215479a0a2e456d8608c4e279cae82b388cfbd5" => :el_capitan
    sha256 "e8021dc6fd643172a39ca47f0a0141e0ca52bc468ef9751970618eae4a62dc96" => :yosemite
    sha256 "906806073787cbeb5f9327b15f5fea8fd626a72ed493a26cbec3aa76801ddb21" => :mavericks
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
