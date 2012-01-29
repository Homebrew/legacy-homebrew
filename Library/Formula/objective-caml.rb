require 'formula'

class ObjectiveCaml < Formula
  url 'http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.1.tar.bz2'
  homepage 'http://caml.inria.fr/ocaml/index.en.html'
  md5 '227a3daaedb150bf5037a3db01f5bf42'

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/objective-caml-3.12.1-bottle.tar.gz'
    sha1 '9bab332759a8262b07b2df46d09ab7c2026837cb'
  end

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make PREFIX=#{prefix} install"

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    ln_s HOMEBREW_PREFIX+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end
end
