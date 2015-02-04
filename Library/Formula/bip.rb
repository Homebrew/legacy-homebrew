class Bip < Formula
  homepage "https://bip.milkypond.org" # Self-signed cert.
  url "https://mirrors.kernel.org/debian/pool/main/b/bip/bip_0.8.9.orig.tar.gz"
  sha256 "3c950f71ef91c8b686e6835f9b722aa7ccb88d3da4ec1af19617354fd3132461"
  revision 1

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/bip"

    system "make", "install"
    (etc+"bip").install "samples/bip.conf"
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
