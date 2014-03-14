require 'formula'

class Fragroute < Formula
  homepage 'http://www.monkey.org/~dugsong/fragroute/'
  url 'http://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz'
  sha1 '0e85daf40f4910d56d75e6cdee163305a1cb9004'

  depends_on 'libdnet'
  depends_on 'libevent'

  patch :p0 do
    url "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/configure.patch"
    sha1 "a858f069dffcb539edbb3fe543200596214669f8"
  end

  patch :p0 do
    url "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/fragroute.c.patch"
    sha1 "a865ee37762c4f31882a2b54a03bf74e5c1b7832"
  end

  patch :p0 do
    url "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/pcaputil.c.patch"
    sha1 "e5fac9731901d5a20d202511ab2acd76a3b12da9"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-libdnet=#{Formula["libdnet"].opt_prefix}"
    system "make", "install"
  end
end
