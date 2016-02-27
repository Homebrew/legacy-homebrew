class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.3.tar.gz"
  sha256 "f3d4f73db7c981e16db2b16d9424b0c75d9fbd30ad81747cac047bc6170b5b49"

  bottle do
    cellar :any
    sha256 "09c3aa649e5dd5833c5114f164ee2f508f140a22bf6e3b5c74741be9f51eba00" => :el_capitan
    sha256 "d1b2e0e9c6715e1ec7407b0e6b6b68fe095b73576cc3b6dfa731bcdd9e3f2169" => :yosemite
    sha256 "515d56bed90b80580312a37aecd838ace36914e8c7b9306ee714cd8b34ef8428" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
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

    output = shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
    assert_match "(6 elems, 1 attrs, 0 spaces, 37 chars)", output
  end
end
