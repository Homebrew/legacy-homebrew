require 'formula'

class ObjectiveCaml <Formula
  url 'http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.0.tar.bz2'
  homepage 'http://caml.inria.fr/ocaml/index.en.html'
  md5 'bd92c8970767f412bc1e9a6c625b5ccf'

  # note it indeed seems necessary to skip cleaning everything
  # see http://github.com/mxcl/homebrew/issues/issue/188
  skip_clean :all

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make world"
    # 'world' can be built in parallel, but the other targets have problems
    ENV.deparallelize
    system "make opt"
    system "make opt.opt"
    system "make install"

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location
    (HOMEBREW_PREFIX+"lib/ocaml/site-lib").mkpath
    ln_s HOMEBREW_PREFIX+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end
end
