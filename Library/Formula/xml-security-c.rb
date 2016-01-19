class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.3.tar.gz"
  sha256 "e5226e7319d44f6fd9147a13fb853f5c711b9e75bf60ec273a0ef8a190592583"

  bottle do
    cellar :any
    sha256 "d80d8ce35414c2afcd87013b5c0279e42ce4d4e22ceb15c904e9750fa3c2aa1f" => :yosemite
    sha256 "c5b52cc0a050efe40157c92cc856cebe5061f3863bc3a872ec8c566da3652326" => :mavericks
    sha256 "5c17003e3418804b1b854177d8ce55eac1686a6c3642d31dbc64494a2d5b930a" => :mountain_lion
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
