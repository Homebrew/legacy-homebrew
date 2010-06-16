require 'formula'

class Couchdb <Formula
  url 'git://github.com/apache/couchdb.git'
  homepage "http://couchdb.apache.org/"
  version "0.11.0"
  @specs = {:tag => "origin/tags/0.11.0"}

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'

  def install
    erlang = Formula.factory "erlang"
    js = Formula.factory "spidermonkey"
    system "./bootstrap" if File.exists? "bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-erlang=#{erlang.lib}/erlang/usr/include",
                          "--with-js-include=#{js.include}",
                          "--with-js-lib=#{js.lib}"
    system "make"
    system "make install"

    (lib+'couchdb/bin/couchjs').chmod 0755
    (var+'lib/couchdb').mkpath
    (var+'log/couchdb').mkpath
  end
end
