require 'formula'

class ObjectiveCaml < Formula
  url 'http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.0.tar.bz2'
  homepage 'http://caml.inria.fr/ocaml/index.en.html'
  md5 'bd92c8970767f412bc1e9a6c625b5ccf'

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make PREFIX=#{prefix} install"

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location
    (HOMEBREW_PREFIX+"lib/ocaml/site-lib").mkpath
    ln_s HOMEBREW_PREFIX+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end
end
