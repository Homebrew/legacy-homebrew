require "formula"

class Metaproxy < Formula
  homepage "http://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.5.10.tar.gz"
  sha1 "898a694131e260569b1b42943e2197d51bc395ce"

  bottle do
    cellar :any
    sha1 "77da0c40789630927c161545f591b5d4b54fda70" => :mavericks
    sha1 "28bfc2375fa226f11abe8e64ae7298423b4958ec" => :mountain_lion
    sha1 "3cbb6e9fe7c49fc55a4c0eebfd692d6b32d555a5" => :lion
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
