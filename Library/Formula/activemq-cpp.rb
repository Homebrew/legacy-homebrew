class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.4/activemq-cpp-library-3.8.4-src.tar.bz2"
  sha256 "9fba18d57f7512ae4f17008d7745d1b4c957b858b585860deadbf9208cb733e3"

  bottle do
    cellar :any
    revision 1
    sha256 "0bd7633a98cbe8099106636b138d0f62bcdd3e1b220dbe2b17acdc87cd9907b8" => :el_capitan
    sha256 "a366fdcfcfe751f70e9d1fa03ef86b7430cf8e2e4e86ad9743e8f564d2aecb8a" => :yosemite
    sha256 "b8a0eac612f83d05b8013092c09c63c012c90b95230afcde4233dc262124b193" => :mavericks
  end

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
