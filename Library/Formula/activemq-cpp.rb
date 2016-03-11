class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.2/activemq-cpp-library-3.9.2-src.tar.bz2"
  sha256 "b3f58fc938cf4fae37192ca317d3d9e4c77caeeeff804ec6f27642201d923bb8"

  bottle do
    cellar :any
    sha256 "5a065ca136501b5f6214f0b1f4779d29bf35cfc3f950c1486bdb324530dfe677" => :el_capitan
    sha256 "708c717db7170bfa7819882c623ae8f5e1973c603479662b760a539cc2ed5979" => :yosemite
    sha256 "07d8c3d296a6d9ba23966e035935d97b08016bff53daabbf2da160aea6c984c2" => :mavericks
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
