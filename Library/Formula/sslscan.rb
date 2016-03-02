class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.2-rbsec.tar.gz"
  version "1.11.2"
  sha256 "d75201af01554827f6aac99fd21ce8eb9469c985fceabd18053098b283679ef7"
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
