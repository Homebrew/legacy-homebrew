require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.6.tar.gz"
  sha256 "f49a852fd63f32ee4f521d8a30ccbd3d1f27a885e17ada25bd854def982a5350"

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
    url "https://github.com/mattn/go-isatty.git", :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git", :revision => "9cbef7c35391cca05f15f8181dc0b18bc9736dbb"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "6acef71eb69611914f7a30939ea9f6e194c78172"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git", :revision => "a71fd10341b064c10f4a81ceac72bcf70f26ea34"
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
