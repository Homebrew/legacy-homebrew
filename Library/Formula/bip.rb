class Bip < Formula
  desc "IRC proxy"
  homepage "https://bip.milkypond.org" # Self-signed cert.
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bip/bip_0.8.9.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/bip/bip_0.8.9.orig.tar.gz"
  sha256 "3c950f71ef91c8b686e6835f9b722aa7ccb88d3da4ec1af19617354fd3132461"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "6668137d523c526718e63487b073d1460be5aad406e0b1e97d03ecf4c151c644" => :el_capitan
    sha256 "7c7f8f20b05207af532ef998b6d967fe09096f91c2d43705538bfe15d56af3bf" => :yosemite
    sha256 "38aa273de07d7ef1057bd253993b19fe359d235a1985230d079cafd549301445" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/bip"

    system "make", "install"
    (etc/"bip").install "samples/bip.conf"
  end

  def caveats; <<-EOS.undent
    Prior to running bip you will need to do:
      mkdir -p ~/.bip/logs
    EOS
  end

  test do
    system bin/"bip", "-v"
  end
end
