class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.0-rbsec.tar.gz"
  version "1.11.0"
  sha256 "698dbf01b9af29aaddf6bce466f568762d852f7b71936861191a3b18d9dda6a5"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "5373126ffd3a5d26069dded06d4999d2fa4884a78b68c0b7b9cde0f7c9100639" => :el_capitan
    sha256 "52d76e298a4bbd5db755626d4bf50f3ea5a4f2af09f7bfb6b6125d3790a70cc2" => :yosemite
    sha256 "3a4dde232387d14e70cb5b3aeb670ccc96bbcc34cb685c0025c9eb087f2c79e4" => :mavericks
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "sslscan"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
