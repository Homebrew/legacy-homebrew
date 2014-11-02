require "formula"

class ActivemqCpp < Formula
  homepage "https://activemq.apache.org/cms/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.3/activemq-cpp-library-3.8.3-src.tar.bz2"
  sha1 "ea67d8b86a524ff57f2a2e0e2451deafacfd6d4b"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end
