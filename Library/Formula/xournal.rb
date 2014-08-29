require "formula"

class Xournal < Formula
  homepage "http://xournal.sourceforge.net"
  url "https://downloads.sourceforge.net/xournal/xournal-0.4.8.tar.gz"
  sha1 "e8b15c427287928e0995cc1b3bc83c2897c689ef"

  depends_on :autoconf
  depends_on :automake
  depends_on "pkg-config" => :build
  depends_on :x11
  depends_on "gtk+"
  depends_on "poppler"
  depends_on "libgnomecanvas"

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end
end
