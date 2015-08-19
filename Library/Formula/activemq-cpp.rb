class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.4/activemq-cpp-library-3.8.4-src.tar.bz2"
  sha256 "9fba18d57f7512ae4f17008d7745d1b4c957b858b585860deadbf9208cb733e3"

  bottle do
    cellar :any
    revision 1
    sha1 "0a9eb28a54a39e34c7acdbf2223bc3e4321b6e0e" => :yosemite
    sha1 "4274dcd894a783d0b59f197feece8e5b1c844575" => :mavericks
    sha1 "4a4fa0eaae9b13720bf78ee95a056ab7165fc07f" => :mountain_lion
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
