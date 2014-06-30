require 'formula'

class Blahtexml < Formula
  homepage 'http://gva.noekeon.org/blahtexml/'
  url 'http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz'
  sha1 '3961f5f388cbc2426aeffd9639a154d5e1690345'

  option 'blahtex-only', "Build only blahtex, not blahtexml"

  depends_on 'xerces-c' unless build.include? 'blahtex-only'

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://trac.macports.org/export/119768/trunk/dports/tex/blahtexml/files/patch-mainPng.cpp.diff"
    sha1 "9f9312930fed9d8b99ddfceb638f0cdfebfc5b73"
  end

  patch :p0 do
    url "https://trac.macports.org/export/119768/trunk/dports/tex/blahtexml/files/patch-main.cpp.diff"
    sha1 "aae4d3f03f450aa09a722b4f3fb4b64de9c62a82"
  end

  def install
    system "make blahtex-mac"
    bin.install 'blahtex'
    unless build.include? 'blahtex-only'
      system "make blahtexml-mac"
      bin.install 'blahtexml'
    end
  end
end
