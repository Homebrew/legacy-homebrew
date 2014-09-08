require 'formula'

class ArgpStandalone < Formula
  homepage 'http://www.lysator.liu.se/~nisse/misc/'
  url 'http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz'
  sha1 '815c560680ebdc11694b88de2f8ec15133e0bfa0'

  bottle do
    cellar :any
    sha1 "3e781159b73d2fbbb22ea626e568904d6f72bd2d" => :mavericks
    sha1 "51228d446622730ba12dfa33e83d41ad79678fef" => :mountain_lion
    sha1 "58936047ba691811df5aa11dbbb4ed2304ef3b8b" => :lion
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
