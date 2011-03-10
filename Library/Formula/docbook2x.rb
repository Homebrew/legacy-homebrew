require 'formula'

class Docbook2x < Formula
  url 'http://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz'
  md5 'b9b76a6af198c4f44574cfd17a322f01'
  homepage 'http://docbook2x.sourceforge.net/'

  depends_on 'docbook'
  depends_on 'XML::NamespaceSupport' => :perl
  depends_on 'XML::SAX' => :perl
  depends_on 'XML::Parser' => :perl
  depends_on 'XML::SAX::Expat' => :perl

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
