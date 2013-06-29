require 'formula'

class PegMarkdown < Formula
  homepage 'https://github.com/jgm/peg-markdown'
  url 'https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz'
  sha1 '95f3e824f97b3c572efe354c965767f46fcf8829'

  head 'https://github.com/jgm/peg-markdown.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system 'make'
    bin.install 'markdown' => 'peg-markdown'
  end
end
