class Monit < Formula
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.13.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/monit/monit_5.13.orig.tar.gz"
  sha256 "9abae036f3be93a19c6b476ecd106b29d4da755bbc05f0a323e882eab6b2c5a9"

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
