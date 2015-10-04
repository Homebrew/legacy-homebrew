class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.2.tar.gz"
  sha256 "743bd0a029bf8de56a587c270d97031e0099fe2b7142cef03e0da16e282655a0"

  bottle do
    cellar :any
    sha256 "583596f0be0dcf3ca798f911c586d7b21c07608910e778681616a1d592b20cae" => :el_capitan
    sha256 "84c60a3ca8979fb96e1bb83382b66cb7d2f8c229ad10cf0db7115d3eecf145ea" => :yosemite
    sha256 "5f61ad9aa1aa9e9a544b5d6fab9661c2e03f208f5d4d61e97e8794028a2341c0" => :mavericks
    sha256 "78151ef964ad93024e36e53e48fb23fa338fdb1b1a347699ec56d8d18c30118c" => :mountain_lion
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
