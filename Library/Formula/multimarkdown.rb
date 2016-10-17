require 'formula'

class Multimarkdown < Formula
  url 'https://github.com/fletcher/peg-multimarkdown.git', :tag => "3.0"
  homepage 'http://fletcherpenney.net/multimarkdown/'
  version "3.0b11"
  head 'https://github.com/fletcher/peg-multimarkdown.git'

  depends_on 'pkg-config'
  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "make"
    bin.install 'multimarkdown'
  end
end
