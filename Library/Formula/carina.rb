class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.3.0",
        :revision => "b611b9dad3f33e1ee9c810ece98a03643b3a4902"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dddc87516c06d1cd5e88a915f23b91308cc6b9301c18fce823758686fa7a5d3" => :el_capitan
    sha256 "3462ea1b0cb963882d479a771da6fd71b5e8cbc517ea953aa7d9d4360ece4e10" => :yosemite
    sha256 "260429922cb3fd08a333a6948cc619e66881df0778ea7f1a6aa70655093f622a" => :mavericks
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
