require "language/go"

class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.1.0.tar.gz"
  sha1 "c57fb6073b374b95262c36959c6d2b6c508cda59"

  bottle do
    cellar :any
    sha1 "db686dbc4dc02122cd98a77c74ca2b57ab859fd9" => :yosemite
    sha1 "e4e8d2339df740dd10f8a396eb2d9f7502cfba55" => :mavericks
    sha1 "3effb5512f9ac39b69b639c067a62239b1171677" => :mountain_lion
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/kr/godep" do
    url "https://github.com/kr/godep.git", :revision => "07a96a1131ddff383e0f502d24c0f989ed0a8bb1"
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

    mkdir_p "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/kr/godep" do
      system "go", "install"
    end

    cd "deisctl" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deisctl"
      bin.install "dist/deisctl"
    end
  end

  test do
    system "#{bin}/deisctl", "help"
  end
end
