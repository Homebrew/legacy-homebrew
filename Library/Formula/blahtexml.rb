require 'formula'

class Blahtexml < Formula
  homepage 'http://gva.noekeon.org/blahtexml/'
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  md5 'ed790599223c2f8f6d205be8988882de'

  depends_on 'xerces-c'

  def install
    system "make blahtex-mac blahtexml-mac"
    bin.install 'blahtex', 'blahtexml'
  end
end
