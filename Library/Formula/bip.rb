class Bip < Formula
  desc "IRC proxy"
  homepage "https://bip.milkypond.org" # Self-signed cert.
  url "https://mirrors.kernel.org/debian/pool/main/b/bip/bip_0.8.9.orig.tar.gz"
  sha256 "3c950f71ef91c8b686e6835f9b722aa7ccb88d3da4ec1af19617354fd3132461"
  revision 1

  bottle do
    cellar :any
    sha256 "73a885e1f2655a3c6d8ff108559e00171a78767dbb57ce79cfbfd77e68362d8c" => :yosemite
    sha256 "a979c86cee1ea3c7cbe99039eda5ae1b8888547a74339b0f8d20a170b331c169" => :mavericks
    sha256 "fb8255c8de05e2cd287352e7a0088cc10b83c2f8a30e2e92af30237c2390d35d" => :mountain_lion
  end

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
