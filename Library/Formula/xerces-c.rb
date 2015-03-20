class XercesC < Formula
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.2.tar.gz"
  sha256 "743bd0a029bf8de56a587c270d97031e0099fe2b7142cef03e0da16e282655a0"

  bottle do
    cellar :any
    sha1 "c967a33a63188465037bad103417e30ae4bcbed8" => :yosemite
    sha1 "d6312f24c9eebe9dadf87785c162c3750ec7c88d" => :mavericks
    sha1 "233d55c81c9d9f97b5f083426cc1c9dbda2bd032" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    EOS

    assert_match /(6 elems, 1 attrs, 0 spaces, 37 chars)/, shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
  end
end
