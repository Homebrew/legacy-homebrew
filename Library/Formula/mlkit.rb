class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.9.tar.gz"
  sha256 "3c6adbeb9a85f7b3586d0961fd3b170ff31e09fa0ff12889b76b9ceb459059c4"

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    system "./autobuild; true"
    system "./configure", "--prefix=#{prefix}"
    ENV.permit_arch_flags
    system "make", "mlkit"
    system "make", "mlkit_libs"
    system "make", "install"
  end

  test do
    system "#{bin}/mlkit", "-V"
  end
end
