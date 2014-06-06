require "formula"

class Zile < Formula
  homepage "https://www.gnu.org/software/zile/"
  url "http://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha1 "ad2efb80031c3a406f8f83ac5d400a38bc297434"

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gettext"
  depends_on "help2man"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
