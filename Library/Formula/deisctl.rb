require "language/go"

class Deisctl < Formula
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.4.1.tar.gz"
  sha1 "4f28c042ae634d92c728b81ea3fed03111b83eb6"

  bottle do
    cellar :any
    sha1 "db686dbc4dc02122cd98a77c74ca2b57ab859fd9" => :yosemite
    sha1 "e4e8d2339df740dd10f8a396eb2d9f7502cfba55" => :mavericks
    sha1 "3effb5512f9ac39b69b639c067a62239b1171677" => :mountain_lion
  end

  depends_on :hg => :build
  depends_on "go" => :build
  
  go_resource "github.com/deis/deis" do
    url "https://github.com/deis/deis.git", :revision => "696064661a70846ccc1780299a714aeff8c4999e"
  end

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://code.google.com/p/go.tools/", :revision => "140fcaadc586", :using => :hg
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV.prepend_create_path "PATH", buildpath/"bin"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    cd "deisctl" do
      system "godep", "go", "build", "-a", "-installsuffix", "cgo", "-ldflags", "-s", "-o", "dist/deisctl"
      bin.install "dist/deisctl"
    end
  end

  test do
    system "#{bin}/deisctl", "help"
  end
end
