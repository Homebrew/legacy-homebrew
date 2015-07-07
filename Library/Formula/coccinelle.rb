require 'formula'

class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage 'http://coccinelle.lip6.fr/'
  url 'http://coccinelle.lip6.fr/distrib/coccinelle-1.0.0-rc21.tgz'
  sha1 'edc008da552eb8f4ef7712fc99b4dc630ab6fb35'

  bottle do
    sha1 "907762ffd74c58637cfc1968c0812cf324ad8ac1" => :yosemite
    sha1 "4d2f9a8af8dca8cce0a3e65c44afc70e38fe7218" => :mavericks
    sha1 "ef567b84ce5bd101e3993e162855e4e88d1f3600" => :mountain_lion
  end

  depends_on "objective-caml"
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
