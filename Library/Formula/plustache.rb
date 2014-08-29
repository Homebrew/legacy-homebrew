require 'formula'

class Plustache < Formula
  homepage 'https://github.com/mrtazz/plustache'
  url 'https://github.com/mrtazz/plustache/archive/v0.3.0.tar.gz'
  sha1 '6ade96f679be0eee049f283ca2d7885f923f2f8d'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
