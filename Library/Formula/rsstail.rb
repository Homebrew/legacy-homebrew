require 'formula'

class Rsstail < Formula
  homepage 'http://www.vanheusden.com/rsstail/'
  url 'http://www.vanheusden.com/rsstail/rsstail-1.8.tgz'
  sha1 '96301a32946ed6ff81bc35d4b875ad1da476121c'

  depends_on 'libmrss'

  def install
    system "make"
    man1.install 'rsstail.1'
    bin.install 'rsstail'
  end
end
