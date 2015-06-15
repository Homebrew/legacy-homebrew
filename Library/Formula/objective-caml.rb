class ObjectiveCaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha256 "3cbc7af5a3886c8c5af8dab5568d6256a191d89ecbd4aea18eaf5b47034c6138"
  revision 2

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  option "with-x11", "Install with the Graphics module"

  depends_on :x11 => :optional

  bottle do
    revision 2
    sha256 "f4d597281214ca019ab564cd0cebdcf18e428fc56ea81c9b289a42f4ec9da17c" => :yosemite
    sha256 "5dc0b0515b58513c35a35b290eea8417f942ee1fdd1891bb8bfc62ddd5ea0889" => :mavericks
    sha256 "3cd3841dec22d0b1309ad781376a4a509c5946cc77a32044dc9f306d906198fc" => :mountain_lion
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
