class Epic5 < Formula
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-1.1.10.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/e/epic5/epic5_1.1.10.orig.tar.bz2"
  sha256 "a4f19214e8eb9a7aceaed62d924d96d8c9359b186ff230c01daff398dd62cdb5"

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6"
    system "make", "install"
  end

  test do
    connection = fork do
      system bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
