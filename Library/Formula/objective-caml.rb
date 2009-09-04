require 'brewkit'

class ObjectiveCaml <Formula
  @url='http://caml.inria.fr/pub/distrib/ocaml-3.11/ocaml-3.11.1.tar.bz2'
  @homepage='http://caml.inria.fr/ocaml/index.en.html'
  @md5='fe011781f37f6b41fe08e0706969a89e'

  def install
    system "./configure --prefix #{prefix}"
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make install"
  end
end
