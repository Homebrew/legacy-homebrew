require 'formula'

class Blahtexml < Formula
  homepage 'http://gva.noekeon.org/blahtexml/'
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  md5 'ed790599223c2f8f6d205be8988882de'

  option 'blahtex-only', "Build only blahtex, not blahtexml"

  depends_on 'xerces-c' unless build.include? '--blahtex-only'

  def install
    system "make blahtex-mac"
    bin.install 'blahtex'
    unless build.include? '--blahtex-only'
      system "make blahtexml-mac"
      bin.install 'blahtexml'
    end
  end
end
