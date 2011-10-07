require 'formula'

class Drizzle < Formula
  url 'http://launchpad.net/drizzle/elliott/2011-03-14/+download/drizzle7-2011.03.13.tar.gz'
  homepage 'http://drizzle.org'
  md5 'e152edfec45779c0bd34ece707aa022d'

  depends_on 'protobuf'
  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'intltool'
  depends_on 'libgcrypt'
  depends_on 'readline'

  skip_clean ['sbin', 'bin']

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
