require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://www.ocaml-lang.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.0.tar.bz2'
  sha1 '22c0ae84c0049e75ec1577d5c1a26c293bb740b3'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  # See http://caml.inria.fr/mantis/view.php?id=5700
  def patches
    "http://caml.inria.fr/mantis/file_download.php?file_id=722&type=bug"
  end

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX,
                          "--mandir", man,
                          "-cc", ENV.cc,
                          "-aspp", "#{ENV.cc} -c"
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
    (lib/'ocaml/compiler-libs').install 'typing', 'parsing', 'utils'

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    ln_s HOMEBREW_PREFIX/"lib/ocaml/site-lib", lib/"ocaml/site-lib"
  end
end
