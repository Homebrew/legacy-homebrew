require 'formula'

class ObjectiveCaml <Formula
  @url='http://caml.inria.fr/pub/distrib/ocaml-3.11/ocaml-3.11.1.tar.bz2'
  @homepage='http://caml.inria.fr/ocaml/index.en.html'
  @md5='fe011781f37f6b41fe08e0706969a89e'
  
  aka :ocaml, 'o-caml'

  def install
    system "./configure --prefix #{prefix}"
    system "make world"
    # 'world' can be built in parallel, but the other targets have problems
    ENV.deparallelize
    system "make opt"
    system "make opt.opt"
    system "make install"
  end

  # note it indeed seems necessary to clean everything
  # see http://github.com/mxcl/homebrew/issues#issue/188
  def skip_clean? path; true; end
end
