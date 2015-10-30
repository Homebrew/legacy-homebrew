require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.5.tar.gz"
  sha256 "416d2547b639b11563d0bd910fa043e532f25fcc40de3ec0d7bec4943747fff1"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d78befdc344dedcfbf20fdae220bf95b191cde92542550612335055002eb90bb" => :el_capitan
    sha256 "e3d3da83f741ee644c1f65788e592820237f41b3ff22c1205ea6377539dd6d42" => :yosemite
    sha256 "61ac23a2cd5348da97dab231a9645c32505d36ff9194d79aa87f58d11de8dde5" => :mavericks
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
