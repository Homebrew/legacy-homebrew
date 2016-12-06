require 'formula'

class XercesJTools < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=xerces/j/source/Xerces-J-tools.2.11.0.tar.gz'
  homepage 'http://xerces.apache.org/xerces2-j'
  md5 '50700B3A6558202B056530BABF80F1DB'
end

class XercesJ < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=xerces/j/source/Xerces-J-src.2.11.0.tar.gz'
  homepage 'http://xerces.apache.org/xerces2-j'
  md5 'd01fc11eacbe43b45681cb85ac112ebf'

  def install
    mkdir "tools"
    tools_dir = pwd + '/tools'

    XercesJTools.new.brew { mv Dir.glob("*"), tools_dir }
    system "/usr/bin/ant jars docs javadocs"

    (share+'java').install Dir['build/*.jar']
    doc.install Dir['build/docs/*']
  end
end
