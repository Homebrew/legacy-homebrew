require 'formula'

class Docbook <Formula
  url 'http://gist.github.com/raw/462528/098ccc609b039cf5b6d11fcd9c8ef333c3861b65/docbook-register'
  md5 '0fbc35a136190050de3598354655fd82'
  version '5.0'
  homepage 'http://docbook.sourceforge.net/'

  def caveats
    <<-EOS.undent
      To use the DocBook package in your XML toolchain, you need to
      register it with the global XML catalog with this command:
      
        sudo docbook-register
    EOS
  end

  def packages; [
    Docbookxml412,
    Docbookxml42,
    Docbookxml43,
    Docbookxml44,
    Docbookxml45,
    Docbookxml50,
    Docbookxsl,
  ]; end

  def install
    bin.install 'docbook-register'
    packages.each do |pkg|
      pkg.new.brew { |formula| formula.install }
    end
  end
end

class Docbookxml <Formula
  def install
    rm_rf 'docs'
    docbook = Formula.factory 'docbook'
    (docbook.prefix+'docbook/xml'+version).install Dir['*']
  end
end
class Docbookxml412 <Docbookxml
  url 'http://www.docbook.org/xml/4.1.2/docbkx412.zip'
  md5 '900d7609fb7e6d78901b357e4acfbc17'
  version '4.1.2'
  homepage 'http://www.docbook.org/'
end
class Docbookxml42 <Docbookxml
  url 'http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip'
  md5 '73fe50dfe74ca631c1602f558ed8961f'
  homepage 'http://www.docbook.org/'
end
class Docbookxml43 <Docbookxml
  url 'http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip'
  md5 'ab200202b9e136a144db1e0864c45074'
  homepage 'http://www.docbook.org/'
end
class Docbookxml44 <Docbookxml
  url 'http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip'
  md5 'cbb04e9a700955d88c50962ef22c1634'
  homepage 'http://www.docbook.org/'
end
class Docbookxml45 <Docbookxml
  url 'http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip'
  md5 '03083e288e87a7e829e437358da7ef9e'
  homepage 'http://www.docbook.org/'
end
class Docbookxml50 <Docbookxml
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  md5 '2411c19ed4fb141f3fa3d389fae40736'
  homepage 'http://www.docbook.org/'
end
class Docbookxsl <Formula
  url 'http://downloads.sourceforge.net/project/docbook/docbook-xsl/1.75.2/docbook-xsl-1.75.2.tar.bz2'
  md5 '0c76a58a8e6cb5ab49f819e79917308f'
  homepage 'http://docbook.sourceforge.net/'
  def install
    doc_files = %w[AUTHORS BUGS README RELEASE-NOTES.txt TODO VERSION NEWS COPYING]
    xsl_files = %w[catalog.xml common eclipse extensions fo highlighting html htmlhelp images javahelp lib manpages params profiling roundtrip slides template tools website xhtml xhtml-1_1]
    docbook = Formula.factory 'docbook'
    (docbook.prefix+'docbook/xsl'+version).install xsl_files + doc_files
  end
end
