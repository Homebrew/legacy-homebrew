require 'formula'

class PcreOcaml < Formula
  url 'http://hg.ocaml.info/release/pcre-ocaml/archive/release-6.2.2.tar.bz2'
  homepage 'http://www.ocaml.info/home/ocaml_sources.html'
  md5 '9c89466d8bb801a6235598b04a98af26'

  depends_on 'objective-caml'
  depends_on 'ocaml-findlib'
  depends_on 'pcre'

  def install
    system 'make'
    mkdir_p "#{prefix}/lib/ocaml/site-lib"
    system "make OCAMLFIND_DESTDIR=#{prefix}/lib/ocaml/site-lib -j 1 install"
  end
end
