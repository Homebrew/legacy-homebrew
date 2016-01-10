class Docbook < Formula
  desc "Standard SGML representation system for technical documents"
  homepage "http://docbook.sourceforge.net/"
  url "http://www.docbook.org/xml/5.0/docbook-5.0.zip"
  sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "3fb7e4070eaa9250fa947d38e3d7803d37c159d9765e3f71397702d5ad6bb578" => :el_capitan
    sha256 "dfdb315404c98dca2682f63260f2996de101cb6b41de69ac268dcded110e2a3f" => :yosemite
    sha256 "65925fda670fdb020fe9d52cd5891f8e3a2a44619e9129b30031127c7c2e998c" => :mavericks
  end

  resource "xml412" do
    url "http://www.docbook.org/xml/4.1.2/docbkx412.zip"
    sha256 "30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772"
    version "4.1.2"
  end

  resource "xml42" do
    url "http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "xml43" do
    url "http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip"
    sha256 "23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464"
  end

  resource "xml44" do
    url "http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip"
    sha256 "02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090"
  end

  resource "xml45" do
    url "http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  resource "xml50" do
    url "http://www.docbook.org/xml/5.0/docbook-5.0.zip"
    sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"
  end

  def install
    (etc/"xml").mkpath

    %w[42 412 43 44 45 50].each do |version|
      resource("xml#{version}").stage do |r|
        if version == "412"
          cp prefix/"docbook/xml/4.2/catalog.xml", "catalog.xml"

          inreplace "catalog.xml" do |s|
            s.gsub! "V4.2 ..", "V4.1.2 "
            s.gsub! "4.2", "4.1.2"
          end
        end

        rm_rf "docs"
        (prefix/"docbook/xml"/r.version).install Dir["*"]
      end
    end
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # only create catalog file if it doesn't exist already to avoid content added
    # by other formulae to be removed
    unless File.file?("#{etc}/xml/catalog")
      system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog"
    end

    %w[4.2 4.1.2 4.3 4.4 4.5 5.0].each do |version|
      catalog = prefix/"docbook/xml/#{version}/catalog.xml"

      system "xmlcatalog", "--noout", "--del",
             "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog",
             "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  def caveats; <<-EOS.undent
    To use the DocBook package in your XML toolchain,
    you need to add the following to your ~/.bashrc:

    export XML_CATALOG_FILES="#{etc}/xml/catalog"
    EOS
  end
end
