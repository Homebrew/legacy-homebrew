class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.2.0",
        :revision => "cbbae4c02e1b8e8420d3da767efdc26fa120dec9"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "5b7211b398a85095d31d33644b9b6006ced08cd19daf2fc95f6bf01fa90544f5" => :el_capitan
    sha256 "2b0d2a0971ff7b9d45d99286aa2695f075662d08050d1da9531478eb3c2e744a" => :yosemite
    sha256 "78d5a1dd0eda7d794d67e45cef86157cb34fb9f04dec550487c4ae83486fe6bd" => :mavericks
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
