class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.7.tar.gz"
  sha256 "9427e6425cb71638d08fcdc45d63190c45ea5a10e28a03def24a9b8bdd584e34"

  bottle do
    sha256 "e5df396714dfff7947bb94d2f2c948d21e08330ca8f1722e357b21f70e88167d" => :el_capitan
    sha256 "e4d052205467c653c2596e5dbec8582559e7da940fa7b611a41b6b157fece804" => :yosemite
    sha256 "d1bcf0796d143f80ca19a1dc599ef91e1d29e9814e4216dea840f71d30f2c701" => :mavericks
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
    require "utils/json"

    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", Utils::JSON.load(output)["browsers"][0]["data"]
  end
end
