require 'formula'

class Coccinelle < Formula
  homepage 'http://coccinelle.lip6.fr/'
  url 'http://coccinelle.lip6.fr/distrib/coccinelle-1.0.0-rc21.tgz'
  sha1 'edc008da552eb8f4ef7712fc99b4dc630ab6fb35'

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
