require 'formula'

class Drizzle <Formula
  url 'http://launchpad.net/drizzle/elliott/2011-01-17/+download/drizzle7-2011.01.08.tar.gz'
  homepage 'http://drizzle.org'
  md5 'e2b26ad273f5d8560b3423716f52931d'

  depends_on 'protobuf'
  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'intltool'
  depends_on 'libgcrypt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
