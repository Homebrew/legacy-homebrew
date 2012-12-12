require 'formula'

class Markdown < Formula
  url 'http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip'
  homepage 'http://daringfireball.net/projects/markdown/'
  sha1 '7e6d1d9224f16fec5631bf6bc5147f1e64715a4b'

  def install
    bin.install 'Markdown.pl' => 'markdown'
  end
end
