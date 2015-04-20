require "formula"

class Dcraw < Formula
  homepage "http://www.cybercom.net/~dcoffin/dcraw/"
  url "http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.22.tar.gz"
  sha1 "f786f12d6cbf2a5571881bcf7f9945365459d433"

  bottle do
    cellar :any
    sha1 "a41d9e98e7c9470a488702da477b9413b9576716" => :mavericks
    sha1 "f4df4c978a8ddb2d6f96ed0627958ab8e326492a" => :mountain_lion
    sha1 "92e4cb2415cde153113b02addb1036fac1cc8dd0" => :lion
  end

  depends_on "jpeg"
  depends_on "jasper"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms2 -ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end
end
