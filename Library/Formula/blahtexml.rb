class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "http://gva.noekeon.org/blahtexml/"
  url "http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz"
  sha256 "c5145b02bdf03cd95b7b136de63286819e696639824961d7408bec4591bc3737"

  option "blahtex-only", "Build only blahtex, not blahtexml"

  depends_on "xerces-c" unless build.include? "blahtex-only"

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://trac.macports.org/export/119768/trunk/dports/tex/blahtexml/files/patch-mainPng.cpp.diff"
    sha256 "7d4bce5630881099b71beedbbc09b64c61849513b4ac00197b349aab2eba1687"
  end

  patch :p0 do
    url "https://trac.macports.org/export/119768/trunk/dports/tex/blahtexml/files/patch-main.cpp.diff"
    sha256 "d696d10931f2c2ded1cef50842b78887dba36679fbb2e0abc373e7b6405b8468"
  end

  def install
    system "make blahtex-mac"
    bin.install "blahtex"
    unless build.include? "blahtex-only"
      system "make blahtexml-mac"
      bin.install "blahtexml"
    end
  end
end
