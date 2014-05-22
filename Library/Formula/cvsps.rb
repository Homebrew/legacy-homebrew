require "formula"

class Cvsps < Formula
  homepage "http://www.catb.org/~esr/cvsps/"
  url "http://www.catb.org/~esr/cvsps/cvsps-3.13.tar.gz"
  sha1 "29d814f9083e3c51bba1b1fadf6c94ed9c2caa1e"

  depends_on "asciidoc"
  depends_on "docbook"

  def install
    # otherwise asciidoc will fail to find docbook
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "all", "cvsps.1"
    system "make", "install", "prefix=#{prefix}"
  end
end
