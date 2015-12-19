class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.1-rbsec.tar.gz"
  version "1.11.1"
  sha256 "0631713b16cea51df49b9666aa17e742e8177d79e85bdb13f66105657c98f169"
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
