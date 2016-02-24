class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.1-rbsec.tar.gz"
  version "1.11.1"
  sha256 "0631713b16cea51df49b9666aa17e742e8177d79e85bdb13f66105657c98f169"
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
    # Note: when next version (>1.11.1) comes out, revise this per https://github.com/Homebrew/homebrew/pull/47229
    rm "INSTALL"
    system "make"
    system "make", "install", "BINPATH=#{bin}", "MANPATH=#{man}/"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
