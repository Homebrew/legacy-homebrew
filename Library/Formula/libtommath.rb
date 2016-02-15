class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "http://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v0.42.0/ltm-0.42.0.tar.bz2"
  mirror "https://distfiles.macports.org/libtommath/ltm-0.42.0.tar.bz2"
  sha256 "7b5c258304c34ac5901cfddb9f809b9b3b8ac7d04f700cf006ac766a923eb217"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "b0f4e06eaf98729a5a8657538f7b9b8cd6f11926f09c34489b3e0b5cfb9bb376" => :el_capitan
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
