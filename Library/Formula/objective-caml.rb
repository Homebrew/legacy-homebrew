require 'formula'

class ObjectiveCaml < Formula
  url 'http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.1.tar.bz2'
  homepage 'http://caml.inria.fr/ocaml/index.en.html'
  md5 '227a3daaedb150bf5037a3db01f5bf42'

  bottle do
    sha1 'e5e28c74b859b8bb15a11f7f2a7a33608671b1b9' => :snowleopard
    sha1 'f32709be6cba5639a3f7185835963d630d6f8b59' => :lion
  end

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
