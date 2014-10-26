require "formula"

class ObjectiveCaml < Formula
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha1 "6af8c67f2badece81d8e1d1ce70568a16e42313e"

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  depends_on :x11 => :recommended

  bottle do
    revision 4
    sha1 "2a6605b51a640356b1ad861d942e0c63ece8facf" => :yosemite
    sha1 "a98ff68b548732ab495ba8b38bc6958fed4c1d37" => :mavericks
    sha1 "bde3be019fb30cc0221ddf78f4725b018f56b651" => :mountain_lion
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
