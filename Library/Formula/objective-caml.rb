class ObjectiveCaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.2.tar.bz2"
  sha256 "b18265582b1c2fd5c1e67da3f744bf1ff474d194bb277c3a9ceb5eb16a1ea703"
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  bottle do
    sha256 "b9cb85c9c8a838217699388af2ac50e6691dc7343889015c23f88c61dd4c227f" => :yosemite
    sha256 "1fe08bc34671612e3a02ed7edd9ffc913e057e14aa747e6d0177933c14209cbd" => :mavericks
    sha256 "7a96850d25a97612fc5a6a53513699ec8f8032574cd1da8d797d2ce068c0f8e7" => :mountain_lion
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
