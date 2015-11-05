class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "http://potrace.sourceforge.net"
  url "http://potrace.sourceforge.net/download/1.13/potrace-1.13.tar.gz"
  sha256 "6252438b6b6644b9b6298056b4c5de3690a1d4e862b66889abe21eecdf16b784"

  bottle do
    cellar :any
    sha256 "f6f72b759dfb5ee3b82aa5a7e384dff6878be5149bb29947b5795c7e3ab24323" => :el_capitan
    sha256 "3df21502abc9a5b5f77252c5db4b9aa3cd437bd9643a7674c3373794de723dfb" => :yosemite
    sha256 "52944612cbb69793f5e17bc4e6608b37206e7dcb8e671c4970f2146fd1db26fe" => :mavericks
  end

  resource "head.pbm" do
    url "http://potrace.sourceforge.net/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert File.exist? "test.eps"
  end
end
