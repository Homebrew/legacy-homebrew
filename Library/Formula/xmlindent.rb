require 'formula'

class Xmlindent < Formula
  homepage 'http://xmlindent.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xmlindent/xmlindent/0.2.17/xmlindent-0.2.17.tar.gz'
  sha1 '024d5c27ae7fd63b012e663c437b3ec46f12b789'

  def install
    inreplace 'Makefile', '-lfl', '-ll'
    inreplace 'indent.c', 'assert(strlen(yytext) == 1);', 'if (strlen(yytext) != 1)  return;'

    system "make"

    bin.mkpath
    bin.install 'xmlindent'

    man.mkpath
    man.install('xmlindent.1')
  end

  def test
    system "xmlindent"
  end
end
