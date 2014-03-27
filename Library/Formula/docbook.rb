require 'formula'

class Docbook < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'

  bottle do
    sha1 "bf3e1674f6e1db1c38e5f56ecc7297f13c3c13f5" => :mavericks
    sha1 "2878dc39a8d6125e3ecc2512462fb22dfba7b9bb" => :mountain_lion
    sha1 "1c8362d72527056fede232590c18c1c23dce41e1" => :lion
  end

  resource 'xml412' do
    url 'http://www.docbook.org/xml/4.1.2/docbkx412.zip'
    sha1 'b9ae7a41056bfaf885581812d60651b7b5531519'
    version '4.1.2'
  end

  resource 'xml42' do
    url 'http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip'
    sha1 '5e3a35663cd028c5c5fbb959c3858fec2d7f8b9e'
  end

  resource 'xml43' do
    url 'http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip'
    sha1 'e79a59e9164c1013b8cc9f64f96f909a184ca016'
  end

  resource 'xml44' do
    url 'http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip'
    sha1 '7c4d91c82ad3747e1b5600c91782758e5d91c22b'
  end

  resource 'xml45' do
    url 'http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip'
    sha1 'b9124233b50668fb508773aa2b3ebc631d7c1620'
  end

  resource 'xml50' do
    url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
    sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
  end

  def install
    (etc/'xml').mkpath
    system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog"

    %w{42 412 43 44 45 50}.each do |version|
      resource("xml#{version}").stage do |r|
        if version == "412"
          cp prefix/'docbook/xml/4.2/catalog.xml', 'catalog.xml'

          inreplace 'catalog.xml' do |s|
            s.gsub! 'V4.2 ..', 'V4.1.2 '
            s.gsub! '4.2', '4.1.2'
          end
        end

        rm_rf 'docs'
        (prefix/'docbook/xml'/r.version).install Dir['*']

        catalog = prefix/"docbook/xml/#{r.version}/catalog.xml"

        system "xmlcatalog", "--noout", "--del",
                             "file://#{catalog}", "#{etc}/xml/catalog"
        system "xmlcatalog", "--noout", "--add", "nextCatalog",
                             "", "file://#{catalog}", "#{etc}/xml/catalog"
      end
    end
  end

  def caveats; <<-EOS.undent
    To use the DocBook package in your XML toolchain,
    you need to add the following to your ~/.bashrc:

    export XML_CATALOG_FILES="#{etc}/xml/catalog"
    EOS
  end
end
