require 'formula'

class Abnfgen < Formula
  homepage 'http://www.quut.com/abnfgen/'
  url 'http://www.quut.com/abnfgen/abnfgen-0.16.tar.gz'
  sha1 '0ed2d09fc1601bb22bcd452000c2e4fd9b2bff81'

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
    system "make install"
  end

  test do
    (testpath/"grammar").write %(ring = 1*12("ding" SP) "dong" CRLF)
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
