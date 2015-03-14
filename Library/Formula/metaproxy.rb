require "formula"

class Metaproxy < Formula
  homepage "http://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.8.3.tar.gz"
  sha1 "d25e1a38aab965f99eb6cb439f1961d118408dcb"

  bottle do
    cellar :any
    sha256 "2cc72713d3fe663eaf79322dbba046038bdd7cde438f26fc4cca03d1a81885e9" => :yosemite
    sha256 "4bc73abfca9681e44e0a76732f6bf9743db91c4f0f0312053c0dec19bd0598c6" => :mavericks
    sha256 "ac81adfebc44cbfdede36ccf7a9e2c8ae528922a0744ed54ab69c3c6a409e58e" => :mountain_lion
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
