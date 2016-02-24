class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "http://4store.org/"
  url "http://4store.org/download/4store-v1.1.5.tar.gz"
  sha256 "2bdd6fb804288802187c5779e365eea2b3ddebce419b3da0609be38edc9e8c5b"

  bottle do
    revision 1
    sha256 "74616c1034dfd440df713febf7b8343e6e4413825ecf7834c57a4538a5aacb37" => :el_capitan
    sha256 "d8e757d9eb36769584853668411a72c63356c468d578238cf3e153465551a888" => :yosemite
    sha256 "404164a3d01bcec3d92311e76c149928cfc69151132cb1a9168770f3bd1ab9a1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "pcre"

  def install
    (var/"fourstore").mkpath
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
    assert_match version.to_s, shell_output("#{bin}/4s-admin --version")
  end
end
