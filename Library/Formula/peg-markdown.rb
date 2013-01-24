require 'formula'

class PegMarkdown < Formula
  homepage 'https://github.com/jgm/peg-markdown'
  url 'https://github.com/jgm/peg-markdown/tarball/0.4.14'
  sha1 '5afa123c513fc259b270a0865bf8382fe314f086'

  head 'https://github.com/jgm/peg-markdown.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system 'make'
    bin.install 'markdown' => 'peg-markdown'
  end
end
