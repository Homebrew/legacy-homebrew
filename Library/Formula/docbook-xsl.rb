class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "http://docbook.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/docbook/docbook-xsl/1.78.1/docbook-xsl-1.78.1.tar.bz2"
  sha256 "c98f7296ab5c8ccd2e0bc07634976a37f50847df2d8a59bdb1e157664700b467"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8598bedecfd34bfa552d83fbc1a94236fcaab2ff06238ffdc037916dcd57faec" => :el_capitan
    sha256 "787f44fdcab7c85bedb4cb34020f706a5ebae0c920814e96e0d959514d26f808" => :yosemite
    sha256 "73e392097207550fe56679cf96e42ddf8ba265cf7d6438be77b2addb18a4f5d1" => :mavericks
  end

  depends_on "docbook"

  resource "ns" do
    url "https://downloads.sourceforge.net/project/docbook/docbook-xsl-ns/1.78.1/docbook-xsl-ns-1.78.1.tar.bz2"
    sha256 "cf8ede7284d7f825c24b95ea273551439c55e9af9a4209ac89e3a7d915607af4"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files + ["README.ns"]
    end

    bin.write_exec_script "#{prefix}/docbook-xsl/epub/bin/dbtoepub"
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    [prefix/"docbook-xsl/catalog.xml", prefix/"docbook-xsl-ns/catalog.xml"].each do |catalog|
      system "xmlcatalog", "--noout", "--del", "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog", "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end
end
