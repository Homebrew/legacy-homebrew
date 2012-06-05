require 'formula'

class Drizzle < Formula
  homepage 'http://drizzle.org'
  url 'https://launchpad.net/drizzle/7.1/7.1.33/+download/drizzle-7.1.33-stable.tar.gz'
  md5 '80dbbbdb3ba0ae0059e77cc59e05e45b'

  depends_on 'protobuf'
  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'intltool'
  depends_on 'libgcrypt'
  depends_on 'readline'

  skip_clean ['sbin', 'bin']

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
