class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.4.tar.gz"
  sha256 "8a6e167f6a9330ccf37c652e577792c9c626d7134d64f841eb54fefcdff6c5ce"

  bottle do
    sha256 "e55d00891372ed68169bb759c7113fb47951793146287f58542f05033966b0a6" => :el_capitan
    sha256 "e823561ca8d621ab0e33fa32e8750c9a29eb381ac8f3ed14001a6d90dce14812" => :yosemite
    sha256 "ea928044dc0a5309be812828d29e75d4cba36300b269aa355f117a2489c8274f" => :mavericks
  end

  head do
    url "https://github.com/allinurl/goaccess.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-geoip", "Enable IP location information using GeoIP"

  deprecated_option "enable-geoip" => "with-geoip"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "geoip" => :optional

  def install
    system "autoreconf", "-vfi" if build.head?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    require "json"

    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", JSON.parse(output)["browsers"][0]["data"]
  end
end
