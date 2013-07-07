require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://www.ocaml-lang.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.1.tar.bz2'
  sha1 '10b8a4d0b88d20b003e3dd719f2ac9434e6a1042'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  depends_on :x11 if MacOS::X11.installed?

  bottle do
    revision 1
    sha1 '523b9d6224d1920fd8727eda0e2faa0354d5cdb8' => :mountain_lion
    sha1 '0a5d13d5bf7d9aa294623e1a6ba250288d25a076' => :lion
    sha1 '22c9a38f4b36c50d58ae28437efd23ce00698164' => :snow_leopard
  end

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX,
                          "--mandir", man,
                          "-cc", ENV.cc,
                          "-with-debug-runtime",
                          "-aspp", "#{ENV.cc} -c"
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"

    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    ln_s HOMEBREW_PREFIX/"lib/ocaml/site-lib", lib/"ocaml/site-lib"
  end
end
