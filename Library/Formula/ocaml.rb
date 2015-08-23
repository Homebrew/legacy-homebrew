# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp4
# - opam
#
# Applications that really shouldn't break on a compiler update are:
# - mldonkey
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  stable do
    url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.3.tar.gz"
    sha256 "928fb5f64f4e141980ba567ff57b62d8dc7b951b58be9590ffb1be2172887a72"
  end

  bottle do
    cellar :any
    sha256 "8b0f9c7ce7b8a710c00f3363709dfa7cee46d2c8d18af6a88affb348eb6a0adb" => :yosemite
    sha256 "afa78cad62971725b4eab39e9d15bc49b7ae224f42c2a27e2bfbe6fad7b292a9" => :mavericks
    sha256 "a0fcad6dc20417725ff9fefb0468ead98a6faa0bb4a99a63351171e4b0dc22b1" => :mountain_lion
  end

  option "with-x11", "Install with the Graphics module"

  depends_on :x11 => :optional

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = ["-prefix", "#{HOMEBREW_PREFIX}", "-with-debug-runtime", "-mandir", man]
    args << "-no-graph" if build.without? "x11"
    system "./configure", *args

    system "make", "world.opt"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "val x : int = 1", shell_output("echo 'let x = 1 ;;' | ocaml 2>&1")
    assert_match "#{HOMEBREW_PREFIX}", shell_output("ocamlc -where")
  end
end
