require 'formula'

class PegMarkdown < Formula
  head 'https://github.com/jgm/peg-markdown.git'
  homepage 'https://github.com/jgm/peg-markdown'

  depends_on 'glib' #brew deps glib -> gettext, pkg-config

  def install
    system 'make'
    bin.install 'markdown'
  end
end
