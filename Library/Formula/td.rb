require "language/go"

class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.3.0.tar.gz"
  sha256 "d138fd1798cf828fe6291cf3faf447ce9abbfa29ae5ff5ede977b7cb5dfc8db0"

  bottle do
    cellar :any
    sha256 "d179a7f6a9e29d08c10c6f3a96e4a234c2cffb241955b179a8dedf182fe9f986" => :yosemite
    sha256 "61ae9c8acb8dd104260f8a17bc3a6edb5238ff501b71d8318474158a44f89399" => :mavericks
    sha256 "b51a8354038f95935dae37df2273b979acdb09bb4c138139d56094df23eaeee4" => :mountain_lion
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
