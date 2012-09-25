require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/tarball/0.7.1'
  sha1 'f55e886f022c965e5f21c3ae49f41762ff9af1b4'

  depends_on "objective-caml"
  depends_on "wget"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/opam --help"
  end

  def caveats; <<-EOS.undent
    opam uses ~/.opam by default to install packages, you need to init package
    database first by running:

      opam init

    and add the following line to ~/.profile to initialize opam environment:

      eval `opam config -env`
    EOS
  end
end
