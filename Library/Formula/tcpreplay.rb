require "formula"

class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.1.0/tcpreplay-4.1.0.tar.gz"
  sha1 "9723d82a0136d963bcc2665d562cb562d216a1c1"

  bottle do
    cellar :any
    sha1 "4ad7a57a4ad4730cd48096fe547f81345726d186" => :yosemite
    sha1 "6530b5c80d93381072019dfdc0caf96775b028f3" => :mavericks
    sha1 "91ad4549dea2d5e715611fb82bd967da9896561d" => :mountain_lion
  end

  depends_on "libdnet" => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link",
                          "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpreplay", "--version"
  end
end
