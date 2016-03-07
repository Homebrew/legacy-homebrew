class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.4-rbsec.tar.gz"
  version "1.11.4"
  sha256 "25720c0caf25a1a81841417658201030ac17c20be59e14dc466c79a92c7bfe10"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "371acab9705b799d0d8b4513d0e925627bbf5266f468f56bb6ca519d9ffd7bb3" => :el_capitan
    sha256 "25a6a1627ff94675962d125e09278c808c05ee14ace63b0f2137f1959b6aa60b" => :yosemite
    sha256 "e1f6ac13e6d326995bb0aa481766f7e693d570b8ecfb783afcb8a5ece5d6dc21" => :mavericks
  end

  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
