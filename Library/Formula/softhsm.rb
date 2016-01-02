class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.0.0.tar.gz"
  sha256 "eae8065f6c472af24f4c056d6728edda0fd34306f41a818697f765a6a662338d"

  bottle do
    sha256 "6fc11217ed26c6db4c219c1bca0f264124cd0b0e7f455bcd670d2c2d481a0b90" => :yosemite
    sha256 "1f4596c4b604987a823fb1d97631e628889fca6c1bbdba4075a0d82be6b04941" => :mavericks
    sha256 "760f9931d96b3cea3d63be22a6f950087544f56c0810b86054099efe43fb00de" => :mountain_lion
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
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = "#{testpath}/softhsm2.conf"
    system *%W[#{bin}/softhsm2-util --init-token --slot 0 --label testing --so-pin 1234 --pin 1234]
    system *%W[#{bin}/softhsm2-util --show-slots]
  end
end
