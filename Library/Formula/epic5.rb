class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-1.1.10.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/e/epic5/epic5_1.1.10.orig.tar.bz2"
  sha256 "a4f19214e8eb9a7aceaed62d924d96d8c9359b186ff230c01daff398dd62cdb5"

  bottle do
    sha256 "91315372bd0f8ac3604263eca9a05d1c894ee9fa1bec255249d8a45c23127c66" => :yosemite
    sha256 "772359b5b050ab8fbca51c802e0d8856b61925e458a7d9ebee8941bfadc33b48" => :mavericks
    sha256 "6c320f0437d0e2dd85b758b35259a258cd9053cb2e8450e0346dd228212d0aea" => :mountain_lion
  end

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
