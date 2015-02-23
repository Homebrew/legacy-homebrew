class ActivemqCpp < Formula
  homepage "https://activemq.apache.org/cms/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.4/activemq-cpp-library-3.8.4-src.tar.bz2"
  sha1 "7c0c79833f1647df3905948f3b8f2592bc7a8994"

  bottle do
    cellar :any
    sha1 "aa3411a43d75c8e21df2a15895ca2fefdd73d1fd" => :yosemite
    sha1 "8108b14f55b2718b91d740f1cef1a2d1a19077ce" => :mavericks
    sha1 "aa809055878e2d6f617debbd4a02e5e50afd04f7" => :mountain_lion
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
