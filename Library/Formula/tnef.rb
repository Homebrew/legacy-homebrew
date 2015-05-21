require "formula"

class Tnef < Formula
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.12.tar.gz"
  sha256 "fefea5d9481555cc150ab799b9b1e957564e7fd2ead99fa19e87258f263f7c37"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
