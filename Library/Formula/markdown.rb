require 'formula'

class Markdown < Formula
  homepage 'http://daringfireball.net/projects/markdown/'
  url 'http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip'
  sha1 '7e6d1d9224f16fec5631bf6bc5147f1e64715a4b'

  conflicts_with 'discount',
    :because => 'both markdown and discount ship a `markdown` executable.'

  def install
    bin.install 'Markdown.pl' => 'markdown'
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output("#{bin}/markdown", "foo *bar*\n")
  end
end
