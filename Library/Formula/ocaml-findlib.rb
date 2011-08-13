require 'formula'

class OcamlFindlib < Formula
  url 'http://download.camlcity.org/download/findlib-1.2.7.tar.gz'
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  md5 '000bff723e8d3d727a7edd5b5901b540'

  depends_on 'objective-caml'

  def install
    system './configure', '-config',  "#{prefix}/etc"
    system 'make'
    system "make prefix=#{prefix} OCAML_SITELIB=/lib/ocaml/site-lib \
                 OCAMLFIND_BIN=/bin OCAMLFIND_MAN=/share/man \
                 OCAML_CORE_STDLIB=/lib/ocaml OCAMLFIND_CONF=/etc install"
  end
end
