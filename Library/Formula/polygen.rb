class Polygen < Formula
  desc "Generate random sentences according to a given grammar"
  homepage "http://www.polygen.org"
  url "http://www.polygen.org/dist/polygen-1.0.6-20040628-src.zip"
  sha256 "703c483820b33a5d695e884e58e2723a660930180fde845f38d6135d247c64a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "06ac686d9d0cd5f8a4f55b0be7c1183b4836ed9c2b4661146edd9b467967577a" => :el_capitan
    sha256 "2531dde7c318582b59adcfed715ebc557dcbbb4b0f03b4f8852d93604c5ce07d" => :yosemite
    sha256 "c2f7980dc650c264620eb972a41fb887ad1beb36491191584ed1ac9242bdcec5" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    cd "src" do
      # BSD echo doesn't grok -e, which the makefile tries to use,
      # with weird results; see https://github.com/Homebrew/homebrew/pull/21344
      inreplace "makefile", '-e "open Absyn\n"', '"open Absyn"'
      system "make"
      bin.install "polygen"
    end
  end
end
