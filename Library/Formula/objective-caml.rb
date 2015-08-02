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
class ObjectiveCaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  stable do
    url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.3.tar.gz"
    sha256 "928fb5f64f4e141980ba567ff57b62d8dc7b951b58be9590ffb1be2172887a72"
  end

  bottle do
    cellar :any
    sha256 "b0a69f73027d6bd6fedea3a4828665b0dd2d10c8b4fd14b427c7b76963dfee40" => :yosemite
    sha256 "6eaaae269acbe7353b058f12f5f9d52ead4e7921f0e21dffe9aaab6fdf79d23e" => :mavericks
    sha256 "638b4c9d3cef687b895b24bb9dd0e3f042aa3def5c8446636c0b389196593181" => :mountain_lion
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
