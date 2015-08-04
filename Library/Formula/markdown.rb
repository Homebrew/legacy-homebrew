class Markdown < Formula
  desc "Text-to-HTML conversion tool"
  homepage "http://daringfireball.net/projects/markdown/"
  url "http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip"
  sha256 "6520e9b6a58c5555e381b6223d66feddee67f675ed312ec19e9cee1b92bc0137"

  conflicts_with "discount", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    bin.install "Markdown.pl" => "markdown"
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output("#{bin}/markdown", "foo *bar*\n")
  end
end
