require "language/go"

class Cig < Formula
  desc "CLI app for checking the state of your git repositories"
  homepage "https://github.com/stevenjack/cig"
  url "https://github.com/stevenjack/cig/archive/v0.1.4.tar.gz"
  sha256 "2a404649fa9041ddff6e37838d8309e8f2cf7fb7463122035ab8522343842c46"
  head "https://github.com/stevenjack/cig.git"

  bottle do
    cellar :any
    sha256 "38986c3def39f3df4b4d7c210e6b5ef9716c9e390499e614058229a97a1ec994" => :yosemite
    sha256 "3d396bb911d6214d866706337e76546dbfe26eb1fc7bc88d19e0afef43b9880b" => :mavericks
    sha256 "f49f5732e6e6a69692a2dabfbe3e2e04914edb11a578dd95c5e8ee328a4b7ddb" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  go_resource "github.com/stevenjack/cig" do
    url "https://github.com/stevenjack/cig.git", :revision => "9c35c2f5862fabb5896da89b54f2c88556a5c04c"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    system "./bin/godep", "go", "build", "-o", "cig", "."
    bin.install "cig"
  end

  test do
    repo_path = "#{testpath}/test"
    system "git", "init", "--bare", repo_path
    (testpath/".cig.yaml").write <<-EOS.undent
      test_project: #{repo_path}
    EOS
    system "#{bin}/cig", "--cp=#{testpath}"
  end
end
