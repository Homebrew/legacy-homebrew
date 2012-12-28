require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/tarball/0.8.2'
  sha1 'a1a16cda2c58064d2f7e644da5fb045783d7b23d'

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
