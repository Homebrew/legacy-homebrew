require 'formula'

class PegMarkdown < Formula
  homepage 'https://github.com/jgm/peg-markdown'
  url 'https://github.com/jgm/peg-markdown/tarball/0.4.12'
  md5 '9e8d3a4897d0e5be84011ec1d3dd961f'
  head 'https://github.com/jgm/peg-markdown.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system 'make'
    bin.install 'markdown' => 'peg-markdown'
  end
end
