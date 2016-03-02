class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.2-rbsec.tar.gz"
  version "1.11.2"
  sha256 "d75201af01554827f6aac99fd21ce8eb9469c985fceabd18053098b283679ef7"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    revision 1
    sha256 "aa0e2014b067ab8c98958007fab3ef1416b8ba79d9f9b5abf522be2d8375e751" => :el_capitan
    sha256 "b552e3fd368382501a203d193373f62a6e18a4996cc7bc0df7b0c75218449521" => :yosemite
    sha256 "6dde7ff7cad621d7c217f3b8cbc612792a3a58abdc409ecb0b4ca29cb126bc8f" => :mavericks
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
