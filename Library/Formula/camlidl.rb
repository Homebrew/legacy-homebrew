require 'formula'

class Camlidl < Formula
  url 'http://caml.inria.fr/pub/old_caml_site/distrib/bazar-ocaml/camlidl-1.05.tar.gz'
  homepage 'http://caml.inria.fr/pub/old_caml_site/camlidl/'
  md5 '4cfb863bc3cbdc1af2502042c45cc675'

  depends_on 'objective-caml'

  def install
    objective_caml = Formula.factory('objective-caml')

    system "cp config/Makefile.unix config/Makefile"
    ENV['OCAMLLIB'] = objective_caml.lib+"/ocaml"
    ENV['OCAMLBIN'] = objective_caml.bin

    system "make all"
    system "make install"
  end
end
