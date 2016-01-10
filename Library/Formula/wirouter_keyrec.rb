class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "http://www.salvatorefresta.net/tools/"
  url "http://tools.salvatorefresta.net/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"

  bottle do
    sha256 "65d21ba4cb167dd2cca395dd5b51edc1ddd0df06fc65843cd2d2eba9e307ea11" => :yosemite
    sha256 "b5740e7929fc911881e007103921c712483971accb581bd5fdb86357f65b8312" => :mavericks
    sha256 "fb6bc3066b31fde62280752b2795e13d8850011f5910ad28dbb1c9e15208af74" => :mountain_lion
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
