require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/tarball/0.7.3'
  sha1 'ef2b8e8bb36d554315b56fd866688704577db053'

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
