require 'formula'

class Jocaml < Formula
  homepage 'http://http://jocaml.inria.fr/'
  url 'http://jocaml.inria.fr/pub/distri/jocaml-3.12/jocaml-3.12.1.tar.gz'
  sha1 '34c8954c766c7a7b50ba10006b10129b924ecb4b'

  depends_on 'ocaml'

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
    (lib+'ocaml/compiler-libs').install 'typing', 'parsing', 'utils'

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    ln_s prefix+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end
end
