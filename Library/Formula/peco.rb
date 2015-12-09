require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.5.tar.gz"
  sha256 "416d2547b639b11563d0bd910fa043e532f25fcc40de3ec0d7bec4943747fff1"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f42983ae2cdb2f8f4c583becbad5c708b95a9e9fbf474d80ee2abf813e16cd7" => :el_capitan
    sha256 "f327e9d88ef8f10a405b6296868b5782743d047b4b8df7b25647ad0b92c07062" => :yosemite
    sha256 "f341d17b7831b69486f632ed0b762610d47de56d364d4cf31e69ef49c67cc9ca" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
      :revision => "cc6329d4279e3f025a53a83c397d2339b5705c45"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "fc93116606d0a71d7e9de0ad5734fdb4b8eae834"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "12e0ff74603c9a3209d8bf84f8ab349fe1ad9477"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "62033d80b58736ea31beaf43348f5147913af30e"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/peco"
    ln_s buildpath, buildpath/"src/github.com/peco/peco"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/peco/peco.go"
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
