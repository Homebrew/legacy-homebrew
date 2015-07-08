class Tcptrace < Formula
  desc "Analyze tcpdump output"
  homepage "http://www.tcptrace.org/"
  url "http://www.tcptrace.org/download/tcptrace-6.6.7.tar.gz"
  sha256 "63380a4051933ca08979476a9dfc6f959308bc9f60d45255202e388eb56910bd"

  bottle do
    cellar :any
    sha256 "f9de7ef41a2b9dc8daee1fddef1035ddf6a08cf473b6edafcf4bb069ab5f0052" => :yosemite
    sha256 "03ecc0ca3c3be27ccf8bcf88be26fb03addecbd14cc1283cab7947d39f9da6ae" => :mavericks
    sha256 "a76f62f4da583260948fb22f69d123c2c6d64e92236fb67c40a37bbe492d08e0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "tcptrace"

    # don't install with owner/group
    inreplace "Makefile", "-o bin -g bin", ""
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    touch "dump"
    assert_match(/0 packets seen, 0 TCP packets/,
      shell_output("#{bin}/tcptrace dump"))
  end
end
