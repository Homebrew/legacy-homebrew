require 'formula'

class Blahtexml < Formula
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.8-src.tar.gz'
  homepage 'http://gva.noekeon.org/blahtexml/'
  md5 '2858418d85ca2afdf46ce67eb4d50de8'

  depends_on 'xerces-c'

  def install
    system "/usr/bin/make blahtex-mac"
    bin.install('blahtex')
    system "/usr/bin/make blahtexml-mac"
    bin.install('blahtexml')
  end
end
