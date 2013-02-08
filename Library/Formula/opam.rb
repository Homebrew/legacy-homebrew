require 'formula'

class Opam < Formula
  homepage 'https://github.com/OCamlPro/opam'
  url 'https://github.com/OCamlPro/opam/archive/0.9.2.tar.gz'
  sha1 '993ad778101589bbad089e34922d0e60180698a0'

  depends_on "objective-caml"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"

    bash_completion.install "shell/opam_completion.sh"
    zsh_completion.install "shell/opam_completion_zsh.sh"
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

    Documentation and tutorials are available at http://opam.ocamlpro.com, or
    via 'man opam' and 'opam --help'.
    EOS
  end
end
