class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v0.9.0",
        :revision => "8e283d93f259cbc3c695cb22e18888603567a081"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "693a09c960ea7b556d2e5a03182c2493ea1ed9f09b640902eb6b51b74bb89caa" => :el_capitan
    sha256 "a7081a20ce82853bb4ef521eb732c0fa77c42a1e574bda9366cd1eae86b92c0f" => :yosemite
    sha256 "46d8952fcac194535d8bd8aa33239c6f14fbbb09426c6517555ee9e41937e63b" => :mavericks
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
