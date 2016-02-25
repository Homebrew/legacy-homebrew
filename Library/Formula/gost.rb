require "language/go"

class Gost < Formula
  desc "Simple command-line utility for easily creating Gists for Github."
  homepage "https://github.com/wilhelm-murdoch/gost"
  url "https://github.com/wilhelm-murdoch/gost/archive/1.1.1.tar.gz"
  sha256 "6e932ad58c9147a6d08528f16d5e496441e577a6175ddca10fbaffcd077a080a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1b473716ce46ea5dc6360b2721df68040c676a53fb9b09b819a480f5620b831" => :el_capitan
    sha256 "556404ce4c4fd2b7fe78df8d059e1185bbb793343c523b246d08fd21227e0bee" => :yosemite
    sha256 "85283889c48ec714015969840e83cdbcef0dc8acc9558744ba969ddcb0b7c1bd" => :mavericks
    sha256 "88c83dde87a0890a85e478ceeffaa0df7865e4761cb99387b0e1367f46618650" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  go_resource "code.google.com/p/goauth2" do
    url "https://code.google.com/p/goauth2/", :revision => "afe77d958c70", :using => :hg
  end

  go_resource "github.com/atotto/clipboard" do
    url "https://github.com/atotto/clipboard.git", :revision => "dfde2702d61cc95071f9def0fe9fc47d43136d6d"
  end

  go_resource "github.com/docopt/docopt.go" do
    url "https://github.com/docopt/docopt.go.git", :revision => "7fb3e64728058525f5940d913d0b854474dcd66a"
  end

  go_resource "github.com/google/go-github" do
    url "https://github.com/google/go-github.git", :revision => "62a50bb14ba982864a5f54e344d0e05764fb41b1"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git", :revision => "d8840cbb2baa915f4836edda4750050a2c0b7aea"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gost"
    bin.install "gost"
  end

  test do
    (testpath/"test.txt").write "42"
    system bin/"gost", "--file=test.txt"
  end
end
