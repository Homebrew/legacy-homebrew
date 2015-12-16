class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.0.0",
        :revision => "2d3d3e6bca49e977102ca89fc314537805d1f31b"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c90cf1c09984d3054152a4bcb0ab907127906d0ecb60f0da0e2133202637131" => :el_capitan
    sha256 "e7daa497d4866a3bedb9e646fa94ecf04eb6ec736259c129f73fd2e963cf066c" => :yosemite
    sha256 "1ab90daa87104575d346841b4578be72e3ecb98b98ed1c066421e683d72bef63" => :mavericks
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
