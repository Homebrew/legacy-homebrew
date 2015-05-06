class Metaproxy < Formula
  homepage "http://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.8.8.tar.gz"
  sha256 "c82849e2901607d585967c1708eabcdac9b4a5a780aeb6f2ec044047455f9811"

  bottle do
    cellar :any
    sha256 "005d81f94f30753602aa37135fbc519c4a0cc6cdbfe6e86aeb7db5dcba28ff57" => :yosemite
    sha256 "150b5f3db0e6d4e280dd4b4d959b265e37a3603c09ecac8be59bd25f160c71c0" => :mavericks
    sha256 "d5453ad8eee78fcb604e8791021949b61411a692ee68f57347f69296a168caa6" => :mountain_lion
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
