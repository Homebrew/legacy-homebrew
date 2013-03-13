require 'formula'

class Cvsps < Formula
  homepage 'http://www.catb.org/~esr/cvsps/'
  url 'http://www.catb.org/~esr/cvsps/cvsps-3.10.tar.gz'
  sha1 '8e0b2c66abd521eef2851da2fa5175f14215e9bf'

  depends_on 'asciidoc'
  depends_on 'docbook'

  def install
    # otherwise asciidoc will fail to find docbook
    ENV['XML_CATALOG_FILES'] = etc/'xml/catalog'

    system "make", "all", "cvsps.1"
    system "make", "install", "prefix=#{prefix}"
  end
end
