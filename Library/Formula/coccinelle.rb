class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.4.tgz"
  sha256 "7f823813a2ea299c0f6c01d8419b83c4dc6617116d32ba99d726443a1c22b06d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7ffdc23dd19c52170042169d4c2d1a63113db688edb31b46e7f808fde0c6b05" => :el_capitan
    sha256 "6613d4b067b2454909ba9512d9ccb81028ad0b80468eb0059876f4fa477eb1f1" => :yosemite
    sha256 "895063e8e6f23dfd401d9473b752eb6c96d7c5abdc6cc98d85d4db65d64baa88" => :mavericks
  end

  depends_on "ocaml"
  depends_on "camlp4"
  depends_on "opam" => :build
  depends_on "hevea" => :build

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--enable-ocaml",
                          "--with-pdflatex=no",
                          "--prefix=#{prefix}"
    system "opam", "config", "exec", "--", "make"
    system "make", "install"
  end
end
