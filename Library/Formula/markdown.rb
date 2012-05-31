require 'formula'

class Markdown < Formula
  url 'http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip'
  homepage 'http://daringfireball.net/projects/markdown/'
  md5 'f17b3c2b2830c6fd2fe0098226e59a2f'

  def install
    bin.install 'Markdown.pl' => 'markdown'
  end
end
