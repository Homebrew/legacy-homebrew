class Libexosip < Formula
  homepage "http://www.antisip.com/as/"
  url "http://download.savannah.gnu.org/releases/exosip/libeXosip2-4.1.0.tar.gz"
  sha256 "3c77713b783f239e3bdda0cc96816a544c41b2c96fa740a20ed322762752969d"

  depends_on "pkg-config" => :build
  depends_on "libosip"
  depends_on "openssl"

  def install
    # Extra linker flags are needed to build this on Mac OS X. See:
    # http://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices "\
                          "-framework Security"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
