class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "http://4store.org/"
  url "http://4store.org/download/4store-v1.1.5.tar.gz"
  sha256 "2bdd6fb804288802187c5779e365eea2b3ddebce419b3da0609be38edc9e8c5b"

  bottle do
    sha256 "af6db4040f02b4d05cad3e860030522089e00882b924cf4ac420a08ec1be4cc7" => :yosemite
    sha256 "1999ddd3484593da6fa2579eb9978457bd844c157bff8796182ac2b2ed2e86c5" => :mavericks
    sha256 "d2c2d74e44e4aa14215f2f22778744993140479b3269ab7483f80d980bd14d7b" => :mountain_lion
  end

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
