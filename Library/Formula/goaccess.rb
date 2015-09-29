class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.4.tar.gz"
  sha256 "8a6e167f6a9330ccf37c652e577792c9c626d7134d64f841eb54fefcdff6c5ce"

  bottle do
    sha256 "b794786dbfd4f88154abe3d06ae166d82bb57729a891dc9c8e438f17c9fcd7ff" => :el_capitan
    sha256 "a8f198a65bbc1f78374f4875de7ae292bc4c6468eafc30e1548733cc3c8d4d72" => :yosemite
    sha256 "c3b9794ea9b90361e81630e9550a3ac6d7a3e413e5c61d7dc00fd3f942b1c802" => :mavericks
    sha256 "c4da90f9f07798cc89c94eb158b878a30609f05f8be00b38454256bbe2203b0a" => :mountain_lion
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
