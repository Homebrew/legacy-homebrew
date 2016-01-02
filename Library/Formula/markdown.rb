class Markdown < Formula
  desc "Text-to-HTML conversion tool"
  homepage "https://daringfireball.net/projects/markdown/"
  url "https://daringfireball.net/projects/downloads/Markdown_1.0.1.zip"
  sha256 "6520e9b6a58c5555e381b6223d66feddee67f675ed312ec19e9cee1b92bc0137"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5b025bc09c8b274507cfc5c86da6350560477f24ce109dd5a79f2dafa97d805" => :el_capitan
    sha256 "5e1b8b5388f1b4ceefe3fae528ae83e2fa3f9ed9f27668e8faded36b9ec3274e" => :yosemite
    sha256 "66fffda1a29fd9e2dcddcb52fb9606f21d897bf4680583626b612a95d27b1e04" => :mavericks
  end

  conflicts_with "discount", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    bin.install "Markdown.pl" => "markdown"
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output("#{bin}/markdown", "foo *bar*\n")
  end
end
