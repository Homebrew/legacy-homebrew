class ObjectiveCaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha256 "3cbc7af5a3886c8c5af8dab5568d6256a191d89ecbd4aea18eaf5b47034c6138"
  revision 2

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  option "with-x11", "Install with the Graphics module"

  depends_on :x11 => :optional

  bottle do
    revision 1
    sha1 "ff2aad908892c78304c153c4c744954f1dadc5c7" => :yosemite
    sha1 "624ddd8c46b91daa51658e06d4ac1e3e20012779" => :mavericks
    sha1 "fa162f9f75ea191f0f9dd59298a0b62c2c761118" => :mountain_lion
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = ["-prefix", prefix, "-with-debug-runtime", "-mandir", man]
    args << "-no-graph" if build.without? "x11"
    system "./configure", *args

    system "make", "world.opt"
    system "make", "install"
  end

  test do
    assert_match "val x : int = 1", shell_output("echo 'let x = 1 ;;' | ocaml 2>&1")
  end
end
