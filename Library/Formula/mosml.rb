require 'formula'

class Mosml <Formula
  version '2.01'
  url 'http://www.itu.dk/people/sestoft/mosml/mos201src.tar.gz'
  homepage 'http://www.itu.dk/people/sestoft/mosml.html'
  md5 '74aaaf988201fe92a9dbfbcb1e646f70'

  def install
    cd "src"

    # make a couple of changes to the makefile
    system "sed -i '' -e's|${HOME}/mosml|#{prefix}|' Makefile.inc"
    system "sed -i '' -e's|/lib/cpp|/usr/bin/cpp|' Makefile.inc"
    system "sed -i '' -e's|${MOSMLHOME}/doc|${MOSMLHOME}/share/doc|' Makefile.inc"
    system "sed -i '' -e's|${MOSMLHOME}/lib|${MOSMLHOME}/lib/mosml|' Makefile.inc"
    system "sed -i '' -e's|${MOSMLHOME}/tools|${MOSMLHOME}/lib/mosml|' Makefile.inc"
    system "sed -i '' -e's|ln -s include config||' Makefile"

    # build and install
    system "make world"
    system "make install"
  end
end