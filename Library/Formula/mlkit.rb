class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.8.tar.gz"
  sha256 "337ea3d333c694871f05f9c3ecbf1c05d4bcd1a0993e87801507930a1637a5d4"

  bottle do
    sha256 "32bcf016846a33d8794230567d6b41ab7d703a13eff4568b318073ba2fe61426" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on :tex
  depends_on "gmp"

  def install
    system "./autobuild; true"
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    ENV.permit_arch_flags
    system "make", "mlkit"
    system "make", "mlkit_libs"
    system "make", "install"
  end

  test do
    system "#{bin}/mlkit", "-V"
  end
end
