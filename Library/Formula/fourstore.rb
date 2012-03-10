require 'formula'

class Fourstore < Formula
  url 'http://4store.org/download/4store-v1.1.3.tar.gz'
  homepage 'http://4store.org/'
  md5 'ed5015c95c97a424274f71e7918a9607'

  depends_on 'glib'
  depends_on 'raptor'
  depends_on 'rasqal'

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
