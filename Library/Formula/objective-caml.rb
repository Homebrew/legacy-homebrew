class ObjectiveCaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.2.tar.bz2"
  sha256 "b18265582b1c2fd5c1e67da3f744bf1ff474d194bb277c3a9ceb5eb16a1ea703"
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  bottle do
    sha256 "b9d8aca6567340adbed781ed3e5a7137e21999bd828ff07c766402b4f6070400" => :yosemite
    sha256 "d2e27ecccfb743c52395b24b0b1792e023214a3c7d66031953f6fd4a8a0bbd7e" => :mavericks
    sha256 "620b3d86106535c471cc81f6e2993a72e9c856f98fab012169d2d5428bb878e9" => :mountain_lion
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
