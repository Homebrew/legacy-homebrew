class Libexosip < Formula
  homepage "http://www.antisip.com/as/"
  url "http://download.savannah.gnu.org/releases/exosip/libeXosip2-4.1.0.tar.gz"
  sha256 "3c77713b783f239e3bdda0cc96816a544c41b2c96fa740a20ed322762752969d"

  bottle do
    cellar :any
    sha256 "f00b16bbe31ef9ce893ed3a5e2f832fc64e6abff23ee64bc1200a5c0bcb5a8d4" => :yosemite
    sha256 "72e5336eb6c2d7262783aacc1d5199e0bb8e80bd941660fb8f42346e4d48e075" => :mavericks
    sha256 "3b0e88403755009f44cba62c2afd81dfa54255c35c4f9bd6a72f230fc21deebb" => :mountain_lion
  end

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
