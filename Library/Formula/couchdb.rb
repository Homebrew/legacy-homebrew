require 'formula'

class Couchdb <Formula
  @url='http://apache.abdaal.com/couchdb/0.10.1/apache-couchdb-0.10.1.tar.gz'
  @homepage='http://couchdb.apache.org/'
  @md5='a34dae8bf402299e378d7e8c13b7ba46'

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include"
    system "make"
    system "make install"

    couchjs = "#{prefix}/lib/couchdb/bin/couchjs"
    system "chmod 755 #{couchjs}"

    (var+'lib'+'couchdb').mkpath
    (var+'log'+'couchdb').mkpath
  end
end
