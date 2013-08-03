require 'formula'

class Coccinelle < Formula
  homepage 'http://coccinelle.lip6.fr/'
  url 'http://coccinelle.lip6.fr/distrib/coccinelle-1.0.0-rc17.tgz'
  sha1 '5c13e521578e20d3805f571dc86931cbd8d63ccd'

  depends_on "objective-caml"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
