require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown/tarball/3.1b1'
  md5 'fc09047d271828f068473114becd39d6'
  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['Support/bin/*']
    bin.install Dir['scripts/*']
  end
end
