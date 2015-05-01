class XmlSecurityC < Formula
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.2.tar.gz"
  sha256 "d576b07bb843eaebfde3be01301db40504ea8e8e477c0ad5f739b07022445452"
  revision 1

  bottle do
    cellar :any
    sha1 "2d08293634c4b7ff1e5794dcdee9845f35ca13c9" => :yosemite
    sha1 "82e9096d90dbdcc4edb2043af3c0361787b65a57" => :mavericks
    sha1 "2ca2c2af28a4d7e45bb54110054323a7e220c47b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /All tests passed/, pipe_output("#{bin}/xtest 2>&1")
  end
end
