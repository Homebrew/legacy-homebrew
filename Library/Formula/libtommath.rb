class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  # homepage/url down since ~May 2015
  homepage "http://libtom.org/?page=features&newsitems=5&whatfile=ltm"
  url "http://libtom.org/files/ltm-0.42.0.tar.bz2"
  mirror "https://distfiles.macports.org/libtommath/ltm-0.42.0.tar.bz2"
  sha256 "7b5c258304c34ac5901cfddb9f809b9b3b8ac7d04f700cf006ac766a923eb217"

  bottle do
    cellar :any
    revision 2
    sha256 "e6ed2cbd074bb7b8c2287baac219bf5a928dd84c8fc4c69d178358f3810164fe" => :yosemite
    sha256 "fbc9c911c91862cad93470cac7e03aba2183faeadb6d67d2a15a0e730efc8103" => :mavericks
    sha256 "537f66d9668409f36ef2c2b99bbd02e1a103e86a2603a66dc66c280763ab9c4a" => :mountain_lion
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
  end
end
