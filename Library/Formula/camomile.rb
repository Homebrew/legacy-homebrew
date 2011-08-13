require 'formula'

class Camomile < Formula
  url 'http://prdownloads.sourceforge.net/camomile/camomile-0.8.3.tar.bz2'
  homepage 'http://camomile.sourceforge.net/'
  md5 'c6476bdb4138d222bc14396a82205034'

  depends_on 'objective-caml'
  depends_on 'ocaml-findlib'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make -j 1'
    mkdir_p "#{prefix}/lib/ocaml/site-lib"
    system "make OCAMLFIND_DESTDIR=#{prefix}/lib/ocaml/site-lib install"
  end
end
