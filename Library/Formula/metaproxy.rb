require "formula"

class Metaproxy < Formula
  homepage "http://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.7.0.tar.gz"
  sha1 "e53650a18590e063a5be1439025902ba531c08f6"

  bottle do
    cellar :any
    sha1 "cf6b466ead595af3e3765f2daa9bc28a3cd1de9d" => :yosemite
    sha1 "9ff3ec1b61a28e5c577975f5629aafb2f816e0a5" => :mavericks
    sha1 "7ecaa044f8f01edaa6e56995aa8d8efdccdd8973" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0"?>
    <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
      <start route="start"/>
      <filters>
        <filter id="frontend" type="frontend_net">
          <port max_recv_bytes="1000000">@:9070</port>
          <message>FN</message>
          <stat-req>/fn_stat</stat-req>
        </filter>
      </filters>
      <routes>
        <route id="start">
          <filter refid="frontend"/>
          <filter type="log"><category access="false" line="true" apdu="true" /></filter>
          <filter type="backend_test"/>
          <filter type="bounce"/>
        </route>
      </routes>
    </metaproxy>
    EOS

    system "#{bin}/metaproxy", "-t", "--config", "#{testpath}/test-config.xml"
  end
end
