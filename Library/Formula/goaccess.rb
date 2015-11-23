class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.6.tar.gz"
  sha256 "e848064c8555f95e770aa1c0475c784c094b42e4ae53ff852975f6498d8f649a"

  bottle do
    sha256 "b662cc46389aa92c3faeb233c03ed34f262e4c23fb8485245b63b10d4e8debe6" => :el_capitan
    sha256 "93be499907187b525b43c5c81846f011fd1a13807298730e14a0519909e68342" => :yosemite
    sha256 "9d661644f8617be774cf6a9fca9d363756604f4abb2133761ee798dd8216a062" => :mavericks
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
