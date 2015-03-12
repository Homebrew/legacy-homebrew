class Fourstore < Formula
  homepage "http://4store.org/"
  url "http://4store.org/download/4store-v1.1.5.tar.gz"
  sha256 "2bdd6fb804288802187c5779e365eea2b3ddebce419b3da0609be38edc9e8c5b"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{etc}/fourstore"
    system "make", "install"
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

  test do
    system "#{bin}/4s-backend-setup", "demo"
  end
end
