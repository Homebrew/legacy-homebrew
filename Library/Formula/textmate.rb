require 'formula'

class Textmate < Formula
  homepage 'http://macromates.com/'
  head 'https://github.com/textmate/textmate.git'
  url 'https://github.com/textmate/textmate', :using => :git
  version '9268'
  depends_on 'ninja'
  depends_on 'proctools'
  depends_on 'ragel'
  depends_on 'boost'
  depends_on 'multimarkdown'

  def install
    system "export builddir=`brew --cellar`/textmate ; ./configure && ninja; cp -r /usr/local/Cellar/textmate/Applications/TextMate/TextMate.app ~/Applications"
  end

  def test
    system "echo success"
  end
end
