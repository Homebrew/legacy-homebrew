require 'formula'

class Fragroute < Formula
  homepage 'http://www.monkey.org/~dugsong/fragroute/'
  url 'http://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz'
  sha1 '0e85daf40f4910d56d75e6cdee163305a1cb9004'

  depends_on 'libdnet'
  depends_on 'libevent'

  def patches
    { :p0 => [
      "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/configure.patch",
      "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/fragroute.c.patch",
      "https://trac.macports.org/export/105753/trunk/dports/net/fragroute/files/pcaputil.c.patch"
    ]}
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libevent=#{Formula.factory("libevent").opt_prefix}",
                          "--with-libdnet=#{Formula.factory("libdnet").opt_prefix}"
    system "make", "install"
  end
end
