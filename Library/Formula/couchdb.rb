require 'formula'

class Couchdb <Formula
  @url='http://apache.multihomed.net/couchdb/0.10.0/apache-couchdb-0.10.0.tar.gz'
  @homepage='http://couchdb.apache.org/'
  @md5='227886b5ecbb6bcbbdc538aac4592b0e'

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
