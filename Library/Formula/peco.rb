require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.3.tar.gz"
  sha256 "3d30a8788c2c7cf4ac44bc5ad09415b9b6245c6e842e46b4e234cb844e929c84"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0041828f4e6581f5d381a2b3c9b35bbfde65b16f12b5b3072e91db008918808f" => :el_capitan
    sha256 "f2132e8e5383140a49f9a6cadfa57b5736230cfbbec5a924a0edcc9a80f9ddfe" => :yosemite
    sha256 "62ff8a3489cbfb5bea9257c56b924bd77c61c272131090b5edf2edffd1d66042" => :mavericks
    sha256 "284f41c4f38f65f580c8c0d43704fdf672e22c56a22895664bb0e08ea6c5204f" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
      :revision => "cc6329d4279e3f025a53a83c397d2339b5705c45"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "1b89bf73cd2c3a911d7b2a279ab085c4a18cf539"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "5890272cd41c5103531cd7b79e428d99c9e97f76"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "785b5546a97f27460cfbc4c77132a46b90beb834"
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
