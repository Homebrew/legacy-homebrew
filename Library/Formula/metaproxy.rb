class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "http://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.8.8.tar.gz"
  sha256 "c82849e2901607d585967c1708eabcdac9b4a5a780aeb6f2ec044047455f9811"
  revision 1

  bottle do
    cellar :any
    sha256 "bb618ee8c7f6629f32afcf54fbc87a3fb80882ab42159aefc047592e48a7f6b1" => :yosemite
    sha256 "3ceeb3f4a5fadda4f4df82262f260732ff3c088ff8fbfdf3a0171451e9373004" => :mavericks
    sha256 "1d46ab6054f7e0dbadf5e9f3038c4ff713c0790d4711ec31b4d9545adfcf9cc5" => :mountain_lion
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
