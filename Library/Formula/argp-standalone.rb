require 'formula'

class ArgpStandalone < Formula
  homepage 'http://www.lysator.liu.se/~nisse/misc/'
  url 'http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz'
  sha1 '815c560680ebdc11694b88de2f8ec15133e0bfa0'

  def patches
    # This patch fixes compilation with Clang.
    {:p0 =>
      "https://trac.macports.org/export/86556/trunk/dports/devel/argp-standalone/files/patch-argp-fmtstream.h"
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    lib.install 'libargp.a'
    include.install 'argp.h'
  end
end
