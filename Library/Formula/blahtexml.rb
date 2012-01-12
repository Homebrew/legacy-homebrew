require 'formula'

class Blahtexml < Formula
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  homepage 'http://gva.noekeon.org/blahtexml/'
  md5 'ed790599223c2f8f6d205be8988882de'

  depends_on 'xerces-c'

  def install
    system "/usr/bin/make blahtex-mac"
    bin.install('blahtex')
    system "/usr/bin/make blahtexml-mac"
    bin.install('blahtexml')
  end
end
