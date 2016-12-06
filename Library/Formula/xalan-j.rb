require 'formula'

class XalanJ < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=xml/xalan-j/xalan-j_2_7_1-src.tar.gz'
  homepage 'http://xml.apache.org/xalan-j'
  md5 'fc805051f0fe505c7a4b1b5c8db9b9e3'

  depends_on 'xerces-j'

  def install
    system "/usr/bin/ant all docs javadocs"

    (share+'java').install Dir['build/*.jar']
    doc.install Dir['build/docs/*']
  end
end
