class Softhsm < Formula
  desc "A cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-1.3.7.tar.gz"
  sha256 "d12d6456a85561266d9da427565f3ee3746a35df6670d5e6be75de253c2810a4"

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
