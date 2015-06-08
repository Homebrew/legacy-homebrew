class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-1.6.2.tar.gz"
  sha1 "5bb7a46927b33081820241586fb1112c7802c9de"

  bottle do
    cellar :any
    sha1 "2984798716e4bea8aaeec7e7db201a3867b435f1" => :yosemite
    sha1 "5da62db9b86f601cf987a8972925dcbbdcc2d6c7" => :mavericks
    sha1 "694b147a1d8563d56602f44e1f02923b84238d2d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
