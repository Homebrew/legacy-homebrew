class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "http://www.salvatorefresta.net/tools/"
  url "http://tools.salvatorefresta.net/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"

  bottle do
    sha1 "70d0cc222e0a6215d9ba9868c281603eac63c8a7" => :yosemite
    sha1 "ef0a2fcab2ebcefe87b91946036cd8d22331f54d" => :mavericks
    sha1 "cdbdb678f080ada0d5432f8f2b1c6b0b2f1c8254" => :mountain_lion
  end

  def install
    inreplace "src/agpf.h", %r{/etc}, "#{prefix}/etc"
    inreplace "src/teletu.h", %r{/etc}, "#{prefix}/etc"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "prefix=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}", "BIN_DIR=bin/"
  end

  test do
    system "#{bin}/wirouterkeyrec", "-s", "Alice-12345678"
  end
end
