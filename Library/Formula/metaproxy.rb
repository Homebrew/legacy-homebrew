class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.10.0.tar.gz"
  sha256 "83a282a9aefa71fd073adc2ef1c474e8b594c921da0c2c4b977821bfc3cf5a5e"

  bottle do
    cellar :any
    sha256 "f6cbc71c09aa50f4bd91fdeda648eea5cd58ce6ec33944971dcf436d4cf9d343" => :el_capitan
    sha256 "c1538d34944254ecde70adbd1715f8da2607e1b7513c18ff722f8e37944f33bf" => :yosemite
    sha256 "04c814ff74ccc537a16276f7263d0c0eda416afc2d24390d2525cf9dcf9fbaea" => :mavericks
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
