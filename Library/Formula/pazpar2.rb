require "formula"

class Pazpar2 < Formula
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.43.tar.gz"
  sha1 "470cddff6670dc24ed144cf503beb3ef054c6392"

  bottle do
    cellar :any
    sha1 "c706b67f07dae521a7abf98c4e65530ad262a22b" => :mavericks
    sha1 "34e44849472083c6ab3d0c69c8355d4e1776beb1" => :mountain_lion
    sha1 "943cc0f80a47bfe46db08e3d87648693fc0d9b14" => :lion
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
