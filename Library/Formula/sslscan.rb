class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.1-rbsec.tar.gz"
  version "1.11.1"
  sha256 "0631713b16cea51df49b9666aa17e742e8177d79e85bdb13f66105657c98f169"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "fc1966c79c103f55cd09b1e9e73b9fa813e115364e2d88d9c5d5a2fc5353fcb2" => :el_capitan
    sha256 "a550ac845f1b4da274aea5637bc09c5492536bea05f446a0e5aa3dd8be45c35c" => :yosemite
    sha256 "eda25606cd361b28afbcd64397933d6d22023b821a716aad99f512cc7ef0e838" => :mavericks
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
