require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://www.ocaml-lang.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.0.tar.gz'
  sha1 '9653e76dd14f0fbb750d7b438415890ab9fe2f4e'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
    (lib+'ocaml/compiler-libs').install 'typing', 'parsing', 'utils'

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    ln_s HOMEBREW_PREFIX+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end
end
