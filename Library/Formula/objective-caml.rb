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
  revision 1

  stable do
    url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.2.tar.bz2"
    sha256 "b18265582b1c2fd5c1e67da3f744bf1ff474d194bb277c3a9ceb5eb16a1ea703"

    # Upstream fix for a GC crash issue introduced in 4.02.2
    # See http://caml.inria.fr/mantis/view.php?id=6919
    patch :DATA
  end

  bottle do
    sha256 "08c8d8728d3c1fe56bbf06ef3cc7acd407b902adc029cd50ae5fda1c4e31d9db" => :yosemite
    sha256 "7384240852677805db33e0e8e71cb083eceec378d692edfc1532041f31c841ed" => :mavericks
    sha256 "57e0ed61d2cb90c25ad2982f2a5fd27381b2d8920342cb83e7ba3b03d37c4a81" => :mountain_lion
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
__END__
diff --git a/byterun/minor_gc.c b/byterun/minor_gc.c
index 4aaec96..859a72a 100644
--- a/byterun/minor_gc.c
+++ b/byterun/minor_gc.c
@@ -259,6 +259,8 @@ void caml_empty_minor_heap (void)
     ++ caml_stat_minor_collections;
     caml_final_empty_young ();
     if (caml_minor_gc_end_hook != NULL) (*caml_minor_gc_end_hook) ();
+  } else {
+    caml_final_empty_young ();
   }
 #ifdef DEBUG
   {
