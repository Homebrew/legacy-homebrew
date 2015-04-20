require 'formula'

class ArgpStandalone < Formula
  homepage 'http://www.lysator.liu.se/~nisse/misc/'
  url 'http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz'
  sha1 '815c560680ebdc11694b88de2f8ec15133e0bfa0'

  bottle do
    cellar :any
    revision 1
    sha1 "72d7282e4ca51c5832e68f06bfdd5c144a73973a" => :yosemite
    sha1 "500784846c3a83e25194cb578eedbbba6e2600fa" => :mavericks
    sha1 "232276ab4611f2d1fa315de24fc062a53cfbd7c4" => :mountain_lion
  end

  # This patch fixes compilation with Clang.
  patch :p0 do
    url "https://trac.macports.org/export/86556/trunk/dports/devel/argp-standalone/files/patch-argp-fmtstream.h"
    sha1 "61b2d1f416869666cf3f81e3961a82fcbfa84837"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    lib.install 'libargp.a'
    include.install 'argp.h'
  end
end
