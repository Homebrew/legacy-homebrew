class Monit < Formula
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.12.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/monit/monit_5.12.2.orig.tar.gz"
  sha256 "8ab0296d1aa2351b1573481592d7b5e06de1edd49dff1b5552839605a450914c"

  bottle do
    cellar :any
    sha256 "cf3f0b83a4f97f975cef004a11d21baccd7c82052e037d1899561b0b0537aa4f" => :yosemite
    sha256 "efebb8f670cf73690aedf2003bd539d28d7a9e3fe63982b197552e622dd709f9" => :mavericks
    sha256 "4c04f9b2a533499fd965f76fd7ca28854c7508f79749ba78d3eaa39d744e913f" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make", "install"
    (share/"monit").install "monitrc"
  end

  test do
    system bin/"monit", "-c", share/"monit/monitrc", "-t"
  end
end
