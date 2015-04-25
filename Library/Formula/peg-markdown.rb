class PegMarkdown < Formula
  homepage "https://github.com/jgm/peg-markdown"
  url "https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz"
  sha256 "111bc56058cfed11890af11bec7419e2f7ccec6b399bf05f8c55dae0a1712980"

  head "https://github.com/jgm/peg-markdown.git"

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
