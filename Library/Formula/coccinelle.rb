require 'formula'

class Coccinelle < Formula
  url 'http://coccinelle.lip6.fr/distrib/coccinelle-1.0.0-rc7.tgz'
  homepage 'http://coccinelle.lip6.fr'
  md5 '41527570a0328708c38540df53c451c8'

  depends_on 'ocaml'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make depend"
    system "make all.opt"
    system "make install"
  end

end
