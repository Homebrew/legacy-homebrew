require "formula"

class ObjectiveCaml < Formula
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha1 "6af8c67f2badece81d8e1d1ce70568a16e42313e"

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  depends_on :x11 => :recommended

  bottle do
    sha1 "4ace54d7cc633294edfdbdc443dc64354c4fb81b" => :yosemite
    sha1 "2a8c6d611a2b89eb0b98111f4ee2d9f91295651d" => :mavericks
    sha1 "0c94cafa9f5d910d3af1fa12fb467cd9f01d2951" => :mountain_lion
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
  end

  def post_install
    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    (lib/"ocaml").install_symlink HOMEBREW_PREFIX/"lib/ocaml/site-lib"
  end
end
