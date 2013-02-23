require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://www.ocaml-lang.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.1.tar.bz2'
  sha1 '10b8a4d0b88d20b003e3dd719f2ac9434e6a1042'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  depends_on :x11 if MacOS::X11.installed?

  bottle do
    sha1 'b5c2e3a881fa0080725d83a994d30f1ebc2bb99f' => :mountainlion
    sha1 '0d7ca01705c22e203e9ddff748b944da6cba921b' => :lion
    sha1 'b485f013972629a06f883e080ee1c71055579288' => :snowleopard
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
