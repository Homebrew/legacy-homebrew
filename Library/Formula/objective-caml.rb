require "formula"

class ObjectiveCaml < Formula
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha1 "6af8c67f2badece81d8e1d1ce70568a16e42313e"

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn
  revision 1

  option "with-x11", "Install with the Graphics module"
  depends_on :x11 => :optional

  bottle do
    sha1 "9a734836f27712fbd3a454152100fcd696932bf8" => :yosemite
    sha1 "4d80628d7bea7d38888dd3ceb4fb1393613ccea1" => :mavericks
    sha1 "625826bbc9c7fc5b082abbe59b099f17032a3a00" => :mountain_lion
  end

  def install
    args = %W[
      --prefix #{HOMEBREW_PREFIX}
      --mandir #{man}
      -cc #{ENV.cc}
      -with-debug-runtime
    ]
    args << "-aspp" << "#{ENV.cc} -c"
    args << "-no-graph" if build.without? "x11"

    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "./configure", *args
    system "make", "world"
    system "make", "opt"
    system "make", "opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
    (lib/"ocaml/site-lib").mkpath
  end

  def post_install
    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    (lib/"ocaml").install_symlink HOMEBREW_PREFIX/"lib/ocaml/site-lib"
  end
end
