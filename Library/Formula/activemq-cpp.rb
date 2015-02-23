class ActivemqCpp < Formula
  homepage "https://activemq.apache.org/cms/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.4/activemq-cpp-library-3.8.4-src.tar.bz2"
  sha1 "7c0c79833f1647df3905948f3b8f2592bc7a8994"

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
