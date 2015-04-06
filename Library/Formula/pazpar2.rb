require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.8.7.tar.gz"
  sha1 "e4e5c1c7cdeea7f06c0242c1b85c32b35c52ee69"

  bottle do
    cellar :any
    sha256 "521ff5bfe870f39f40f041bd8ac3f9360cfd6fe4e951437c9c6376e8c8953937" => :yosemite
    sha256 "bb2fd6a3a4418a5fe71cf8bcf3ee71790ab85a3e52f3a02a03ccb2cdd718a44f" => :mavericks
    sha256 "2ad236a1358534e963dcc1538354b741d3644ac24231148fcf79b8f4e63645cc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
      <threads number="2"/>
      <server>
        <listen port="8004"/>
      </server>
    </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
