require "formula"

class Libfixbuf < Formula
  homepage "http://tools.netsa.cert.org/fixbuf/"
  url "http://tools.netsa.cert.org/releases/libfixbuf-1.6.1.tar.gz"
  sha1 "5362e7ae866c418b1ae5576ad9ea3095bd7f2681"

  bottle do
    cellar :any
    sha1 "8d2e38229a45b18c749310718903a8f6da204a97" => :yosemite
    sha1 "91c03b5e52ae2aaef6dd6f02aa16900afb8c721d" => :mavericks
    sha1 "5fa1fc484e39024ba3bbf47fc1741d99cc20d4d4" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
