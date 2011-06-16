require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown/tarball/3.0'
  md5 '607387dc346a71203f100564874294fe'
  head 'https://github.com/fletcher/peg-multimarkdown.git'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "make"
    bin.install 'multimarkdown'
  end
end
