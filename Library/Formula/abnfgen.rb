class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.16.tar.gz"
  sha256 "c256712a97415c86e1aa1847e2eac00019ca724d56b8ee921d21b258090d333a"

  bottle do
    cellar :any
    sha1 "44b60ec95b34c9869787025439ac699bb76e916e" => :yosemite
    sha1 "f24c3fcf1371e5da17994205b887054078de2a92" => :mavericks
    sha1 "ade80460f765a647fe8f2f1457ea54d2ff15219c" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write %(ring = 1*12("ding" SP) "dong" CRLF)
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
