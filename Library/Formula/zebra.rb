class Zebra < Formula
  homepage "http://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.60.tar.gz"
  sha256 "9eac55475ebf52bf0ca9d66b45a0566b91bfa3e27e12dd23f030e23bab920c33"

  bottle do
    sha256 "cb505eeed36fd075c4be64f647cf0f815a5d677e15a727ddf5545559320a2e33" => :yosemite
    sha256 "2c77e22de51cfcb48f9b18856df31c174bb775de5b7d66856cc59f53ec2e78dd" => :mavericks
    sha256 "d8fc8ea2fc4805ab47d7132e383fe5a57cc73b84e0c527399609a824cfca8668" => :mountain_lion
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
