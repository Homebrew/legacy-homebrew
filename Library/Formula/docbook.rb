require 'formula'

class Docbook < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'

  def install
    packages = [Docbookxml412,
                Docbookxml42,
                Docbookxml43,
                Docbookxml44,
                Docbookxml45,
                Docbookxml50,
                Docbookxsl,
                Docbookxslns]

    (etc+'xml').mkpath
    system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog"

    packages.each do |pkg|
      pkg.new.brew do |f|
        f.install
        catalog = prefix+f.catalog+'catalog.xml'
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
    (docbook.prefix+'docbook/xml'+version).install Dir['*']
  end

  def catalog; 'docbook/xml/'+version; end
end

class Docbookxml412 < Docbookxml
  url 'http://www.docbook.org/xml/4.1.2/docbkx412.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
  version '4.1.2'
end

class Docbookxml42 < Docbookxml
  url 'http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end

class Docbookxml43 < Docbookxml
  url 'http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end

class Docbookxml44 < Docbookxml
  url 'http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end

class Docbookxml45 < Docbookxml
  url 'http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end

class Docbookxml50 < Docbookxml
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'
end

class Docbookxsl < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/docbook/docbook-xsl/1.76.1/docbook-xsl-1.76.1.tar.bz2'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'

  def install
    doc_files = %w[AUTHORS BUGS README RELEASE-NOTES.txt TODO VERSION NEWS COPYING]
    xsl_files = %w[catalog.xml common eclipse epub extensions fo highlighting html
                   htmlhelp images javahelp lib manpages params profiling roundtrip
                   slides template tools website xhtml xhtml-1_1]
    docbook = Formula.factory 'docbook'
    (docbook.prefix+'docbook/xsl'+version).install xsl_files + doc_files
  end

  def catalog; 'docbook/xsl/'+version; end
end

class Docbookxslns < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/docbook/docbook-xsl-ns/1.77.1/docbook-xsl-ns-1.77.1.tar.bz2'
  sha1 '49f274e67efdee771300cba4da1f3e4bc00be1ec'

  def install
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    docbook = Formula.factory 'docbook'
    (docbook.prefix+'docbook/xsl-ns'+version).install xsl_files + doc_files
  end

  def catalog; 'docbook/xsl-ns/'+version; end
end
