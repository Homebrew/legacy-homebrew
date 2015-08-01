class PegMarkdown < Formula
  desc "Markdown implementation based on a PEG grammar"
  homepage "https://github.com/jgm/peg-markdown"
  url "https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz"
  sha256 "111bc56058cfed11890af11bec7419e2f7ccec6b399bf05f8c55dae0a1712980"

  head "https://github.com/jgm/peg-markdown.git"

  bottle do
    cellar :any
    sha256 "8b73ccf611b6639935b1fe7b42d5bab2518703f81b182769c537f7224ac1e803" => :yosemite
    sha256 "67d5b05f4cb166d398f352cfa2a1d9ce97ae6ed1a7da5f8012c1d3544ec496d6" => :mavericks
    sha256 "81b615979242abe96da6a8657c9357ad6f59d585a2533db1469b2e9ead567d9b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "make"
    bin.install "markdown" => "peg-markdown"
  end

  test do
    assert_equal "<p><strong>Homebrew</strong></p>",
      pipe_output("#{bin}/peg-markdown", "**Homebrew**", 0).chomp
  end
end
