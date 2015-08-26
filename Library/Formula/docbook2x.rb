class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "http://docbook2x.sourceforge.net/"
  url "https://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"

  depends_on "docbook"
  depends_on "XML::NamespaceSupport" => :perl
  depends_on "XML::SAX" => :perl
  depends_on "XML::Parser" => :perl
  depends_on "XML::SAX::Expat" => :perl

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
