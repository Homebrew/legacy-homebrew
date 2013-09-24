require 'formula'

class ObjectiveCaml < Formula
  homepage 'http://ocaml.org'
  url 'http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0.tar.gz'
  sha1 '31ae98051d42e038f4fbc5fd338c4fa5c36744e0'

  head 'http://caml.inria.fr/svn/ocaml/trunk', :using => :svn

  depends_on :x11 if MacOS::X11.installed?

  bottle do
    sha1 'cba09036b0ddc87f04675f3ceaac2c46b99dcb20' => :mountain_lion
    sha1 '90e110ace80da3e633b3ba0b95530fe5d43045d7' => :lion
    sha1 '5b320577bcb6e39ada153e2de14a105a2afb5ca2' => :snow_leopard
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
