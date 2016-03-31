class Smlsharp < Formula
  desc "Standard ML compiler with practical extensions"
  homepage "http://www.pllab.riec.tohoku.ac.jp/smlsharp/"
  url "http://www.pllab.riec.tohoku.ac.jp/smlsharp/download/smlsharp-3.0.0.tar.gz"
  sha256 "8e3dd0f18b95e6e557e04956f5ee0c5e0e1ecf4abe8f1efa13517ad77e9eb12a"

  depends_on "llvm37"
  depends_on "gmp"
  depends_on "xz" => :build

  def install
    system "./configure",
           "--prefix=#{prefix}",
           "--with-llvm=#{HOMEBREW_PREFIX}/lib/llvm-3.7"
    system "make", "install"
  end

  test do
    assert_match "val it = 0xC : word", shell_output("echo '0w12;' | smlsharp")
  end
end
