class Softhsm < Formula
  desc "A cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-1.3.7.tar.gz"
  sha256 "d12d6456a85561266d9da427565f3ee3746a35df6670d5e6be75de253c2810a4"

  bottle do
    sha256 "2e93310b6db277071b4643e327954fe002270dbb7f9ca43080455eedb6c699c1" => :yosemite
    sha256 "94147927ce8f7f263a89f5423e0c78263af2a2c6ee0e100e735d578b80c8a89e" => :mavericks
    sha256 "5c85b169eb53ba6f4e86344b173d10b6ab6e983bd0638a4fd6273ae5ff8c703a" => :mountain_lion
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
