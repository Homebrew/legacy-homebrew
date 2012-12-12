require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/tarball/0.8.1'
  sha1 '8c5e236bdf8cdb614ff6bbea93ee74655a099bce'

  depends_on "objective-caml"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/opam --help"
  end

  def caveats; <<-EOS.undent
    OPAM uses ~/.opam by default to install packages, so you need to initialize
    the package database first by running (as a normal user):

    $  opam init

    and add the following line to ~/.profile to initialize the environment:

    $  eval `opam config -env`

    Documentation and tutorials are available at http://opam.ocamlpro.com
    EOS
  end
end
