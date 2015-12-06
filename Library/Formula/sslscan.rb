class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.0-rbsec.tar.gz"
  version "1.11.0"
  sha256 "698dbf01b9af29aaddf6bce466f568762d852f7b71936861191a3b18d9dda6a5"
  head "https://github.com/rbsec/sslscan.git"

  depends_on "openssl"

  def install
    system "make"
    bin.install "sslscan"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
