require 'formula'

class Fourstore < Formula
  homepage 'http://4store.org/'
  url 'http://4store.org/download/4store-v1.1.4.tar.gz'
  md5 'e15773fa72bb885f2613a8778fcbb7b6'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{etc}/fourstore"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Databases will be created at #{var}/fourstore.

    Create and start up a database:
        4s-backend-setup mydb
        4s-backend mydb

    Load RDF data:
        4s-import mydb datafile.rdf

    Start up HTTP SPARQL server without daemonizing:
        4s-httpd -p 8000 -D mydb

    See http://4store.org/trac/wiki/Documentation for more information.
    EOS
  end

end
