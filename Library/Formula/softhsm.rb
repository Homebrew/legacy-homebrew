class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-1.3.7.tar.gz"
  sha256 "d12d6456a85561266d9da427565f3ee3746a35df6670d5e6be75de253c2810a4"
  revision 1

  bottle do
    sha256 "3ce8010a15659fd4dd8381d3306d9627892584585cef04bd7ff92d257c3e63af" => :yosemite
    sha256 "ddacb262d557c505d82efb407ab5344390dcf6de231c079ab98e9365d07a8444" => :mavericks
    sha256 "3f0602a61b71182f64093abca6da98d7458ee8a720b1131cdfecf9bef93bab7a" => :mountain_lion
  end

  depends_on "botan"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"softhsm.conf").write("0:#{testpath}/hsm.db")
    ENV["SOFTHSM_CONF"] = "#{testpath}/softhsm.conf"
    system *%W[#{bin}/softhsm --init-token --slot 0 --label testing --so-pin 1234 --pin 1234]
    system *%W[#{bin}/softhsm --show-slots]
  end
end
