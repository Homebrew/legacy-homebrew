class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.4/activemq-cpp-library-3.8.4-src.tar.bz2"
  sha256 "9fba18d57f7512ae4f17008d7745d1b4c957b858b585860deadbf9208cb733e3"

  bottle do
    cellar :any
    revision 1
    sha256 "2498f3693277a93b0607a04ff7dbdecc018a8621535db12964a2abee3d0550fa" => :yosemite
    sha256 "1924f8c680b4f5ce033a915623df17779a63aea9a816961360585bf3071c6a22" => :mavericks
    sha256 "d276773ac0864c7c02bc4a55eac7ee52c73d5d0046ccd7fa5d2ebeb1453f60ee" => :mountain_lion
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
