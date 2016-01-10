require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.5.tar.gz"
  sha256 "dc64a24547c0108fb23cf1cf4654a889e4537d09c8012cd342c8718bb858d59b"

  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dca19f06936474289d24b0085df10d6a9eb1485a5734a7b63b6736f947d5f03" => :el_capitan
    sha256 "1b600cc9c3e97a1f7a8de50ac12c480e6389f3b8a258bcf2aa4befecb6cca97e" => :yosemite
    sha256 "7e2961192bffd7005571dd3e1bb80108aa540ad0fa0134f62733a4c6133c12b7" => :mavericks
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
    url "https://go.googlesource.com/net.git", :revision => "b4e17d61b15679caf2335da776c614169a1b4643"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git", :revision => "cc8a7ec430472eaf28b179c420464d7a9fc741c5"
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
