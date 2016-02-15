class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.10.0.tar.gz"
  sha256 "83a282a9aefa71fd073adc2ef1c474e8b594c921da0c2c4b977821bfc3cf5a5e"
  revision 1

  bottle do
    cellar :any
    sha256 "51d08e2530cb5ca1508e202f2e4c2ccbd10e1b390d007d7bda836f1baa509fd7" => :el_capitan
    sha256 "b4e8a8061d63fb432a034a2c25d2ab27f8075af72d92888b4cc7955da23fc27a" => :yosemite
    sha256 "9c867f515b0aa5dfc5348df0ce384a9bb12ea589fc27d292c18c6d0eadd1284d" => :mavericks
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
