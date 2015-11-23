require "language/go"

class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.3.0.tar.gz"
  sha256 "d138fd1798cf828fe6291cf3faf447ce9abbfa29ae5ff5ede977b7cb5dfc8db0"

  bottle do
    cellar :any
    sha256 "38428b68601f84a7cf0360bea09b17d891bd5bb2a5d6fbc6bce420011de698d2" => :yosemite
    sha256 "f73a1a4e82115217791c73e95938f474f906f5215164abd71d71c9304674895e" => :mavericks
    sha256 "c3e12ecfa1b4c9530f2f27c6707cf8e493377ca6132170814476d715564c536f" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "bca61c476e3c752594983e4c9bcd5f62fb09f157"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/Swatto/"
    ln_sf buildpath, buildpath/"src/github.com/Swatto/td"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "."
    bin.install "td-#{version}" => "td"
  end

  test do
    (testpath/".todos").write "[]"

    system "#{bin}/td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end
