class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.22.0.tar.bz2"
  sha256 "7b030287b4b75f35e6212b145648bec0be6580cc5434caa6d2fe64a38562afd2"

  bottle do
    cellar :any
    revision 1
    sha256 "a07fe04b1663bcf2f0519de97c32e2143645a6cda602ee0481d2483350cdc72e" => :el_capitan
    sha256 "0a46e8571744e0e4ba1c5e0c931c55202086d7b247defecade3a7464ecf61d2d" => :yosemite
    sha256 "2691f8f9e47736d734b551917c792f8984cebfc310b983a5b99a7b66916f092f" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
