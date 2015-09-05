class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.0-rc21.tgz"
  sha256 "a6609a1f800f84d058c9b395edd0597171594b685f551a9b9c03728a1b416783"
  revision 1

  bottle do
    sha256 "8345aa22d8966d5a812a09c7eba291e3b4c62ca233795f2f4ac1ad7f5f718098" => :yosemite
    sha256 "7a6ab8f68cc53737b6f64246d720aa4090246014f9309e69293e0c5516193f62" => :mavericks
    sha256 "8a91d91164c21682355d050b84752a672d725027df95a32654a53aea02ff394f" => :mountain_lion
  end

  depends_on "ocaml"
  depends_on "camlp4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
