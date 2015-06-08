class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.2.tar.gz"
  sha256 "d576b07bb843eaebfde3be01301db40504ea8e8e477c0ad5f739b07022445452"
  revision 1

  bottle do
    cellar :any
    sha256 "23245a36f12b0523492bab218d355a48cad624688a0d96b072fba3d1f46aa3e9" => :yosemite
    sha256 "5c31eab95dc1a56d09e349e11f599360d890449beb4f372c0190c3fa386fec79" => :mavericks
    sha256 "73f5cc7b69cf16f514e18d6257d546f83abd3e7beb3d694c098938e8d5f8daf9" => :mountain_lion
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
