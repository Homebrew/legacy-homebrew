class Httpfs2 < Formula
  desc "FUSE filesystem for mounting files from http servers"
  homepage "http://httpfs.sourceforge.net/"
  url "https://sourceforge.net/projects/httpfs/files/httpfs2/httpfs2-0.1.5.tar.gz"
  version "0.1.5"
  sha256 "01cb4bb38deb344f540da6f1464dc7edbdeb51213ad810b8c9c282c1e17e0fc1"

  depends_on "pkg-config" => :build
  depends_on "dpkg" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gnutls"
  depends_on :osxfuse

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make httpfs2.1"
    bin.install "httpfs2", "httpfs2-mt", "httpfs2-ssl", "httpfs2-ssl-mt"
    man1.install Dir["*.1"]
  end

  test do
    system "httpfs2-ssl-mt"
  end
end
