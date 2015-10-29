require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.4.tar.gz"
  sha256 "c0db7fb232d49a747101649a5519274b19850a62c039d1ac87eb0872f20ed4a7"

  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0c00d693fa7ca52f2e8adb1332a46f2422b0ed76e4ab077e407444af4e4d68" => :el_capitan
    sha256 "db3315c6a7fb876242693979164e373d08413c76c1f3d5ac362201cc5b17ea63" => :yosemite
    sha256 "37ac2473aadf8778e7c20396817468e07185a74e3521f6d0e40c788802ca5080" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git", :revision => "7fcbc72f853b92b5720db4a6b8482be612daef24"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git", :revision => "40e4aedc8fabf8c23e040057540867186712faa5"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "2cba614e8ff920c60240d2677bc019af32ee04e5"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git", :revision => "0fe7e6856182a6ebfcf1e6a7aa90bead9a8e1bc0"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "jvgrep.go"
    bin.install "jvgrep"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/jvgrep", "Hello World!", testpath
  end
end
