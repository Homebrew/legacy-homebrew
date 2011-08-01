require 'formula'

class Uthash < Formula
  url 'http://downloads.sourceforge.net/uthash/uthash-1.9.4.tar.bz2'
  homepage 'http://uthash.sourceforge.net'
  md5 'f8c2d5c560fe0f8d7b26148ea442ae93'

  def install
    system 'make -C tests'

    include.install Dir['src/*']

    system 'rm doc/Makefile doc/NOTES'
    doc.install Dir['doc/*']

    prefix.install 'LICENSE'
  end
end
