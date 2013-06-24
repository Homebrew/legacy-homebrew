require 'formula'

class Docbook < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'

  def install
    # Install 4.1.2 *after* 4.2, because we need to borrow the catalog.xml
    # file from the 4.2 package.
    packages = [Docbookxml42,
                Docbookxml412,
                Docbookxml43,
                Docbookxml44,
                Docbookxml45,
                Docbookxml50]

    (etc/'xml').mkpath
    system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog"

    packages.each do |pkg|
      pkg.new.brew do |f|
        f.install
        catalog = prefix/f.catalog/'catalog.xml'
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

class Docbookxml < Formula
  def install
    rm_rf 'docs'
    docbook = Formula.factory 'docbook'
    (docbook.prefix/'docbook/xml'/version).install Dir['*']
  end

  def catalog
    "docbook/xml/#{version}"
  end
end

class Docbookxml412 < Docbookxml
  url 'http://www.docbook.org/xml/4.1.2/docbkx412.zip'
  sha1 'b9ae7a41056bfaf885581812d60651b7b5531519'
  version '4.1.2'

  def install
    cp Formula.factory('docbook').prefix/'docbook/xml/4.2/catalog.xml', 'catalog.xml'

    inreplace 'catalog.xml' do |s|
      s.gsub! 'V4.2 ..', 'V4.1.2 '
      s.gsub! '4.2', '4.1.2'
    end

    super
  end
end

class Docbookxml42 < Docbookxml
  url 'http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip'
  sha1 '5e3a35663cd028c5c5fbb959c3858fec2d7f8b9e'
end

class Docbookxml43 < Docbookxml
  url 'http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip'
  sha1 'e79a59e9164c1013b8cc9f64f96f909a184ca016'
end

class Docbookxml44 < Docbookxml
  url 'http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip'
  sha1 '7c4d91c82ad3747e1b5600c91782758e5d91c22b'
end

class Docbookxml45 < Docbookxml
  url 'http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip'
  sha1 'b9124233b50668fb508773aa2b3ebc631d7c1620'
end

class Docbookxml50 < Docbookxml
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end
