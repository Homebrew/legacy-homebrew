require 'formula'

class Couchdb <Formula
  url 'git://github.com/apache/couchdb.git', :tag => "origin/tags/1.0.0"
  homepage "http://couchdb.apache.org/"
  version "1.0.0"

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'

  def install
    system "./bootstrap" if File.exists? "bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include",
                          "--with-js-include=#{HOMEBREW_PREFIX}/include",
                          "--with-js-lib=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make install"

    (lib+'couchdb/bin/couchjs').chmod 0755
    (var+'lib/couchdb').mkpath
    (var+'log/couchdb').mkpath
    (etc + "couchdb/local.d/delayed_commits.ini").write ini_file

  end

  def ini_file
    return <<-EOS
[couchdb]
  delayed_commits = false ; See http://couchdb.apache.org/notice/1.0.1.html for details.
EOS
  end

end
