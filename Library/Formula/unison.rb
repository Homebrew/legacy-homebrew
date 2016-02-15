class Unison < Formula
  desc "Unison file synchronizer"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.3.tar.gz"
  sha256 "f40d3cfbe82078d79328b51acab3e5179f844135260c2f4710525b9b45b15483"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "bdd87bd8da922dcafb207de183d7d1c4bc5deaab21ebe5b327da0d61ad404cf1" => :el_capitan
    sha256 "b4f4ebf0db23e5aa52528ec12c6dd84315ed36e4894cefba9c3c85e293ca9350" => :yosemite
    sha256 "790d915ca2e98518227626ad2ce91b53f60ce584f4ca8c8392c30a4917e2e167" => :mavericks
    sha256 "dc4dcbeb2e2f224f9fffede14f8d3c7c220f032023b83626b75409707e93df35" => :mountain_lion
  end

  depends_on "ocaml" => :build

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install "unison"
  end
end
