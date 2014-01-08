require 'formula'

class Opam < Formula
  homepage 'https://opam.ocaml.org'
  url 'https://github.com/ocaml/opam/archive/1.1.0.tar.gz'
  sha1 'fe66f5cfc9ffe9f621462e52e17cbb5869de419a'

  head 'https://github.com/ocaml/opam.git'

  depends_on "objective-caml"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "shell/opam_completion.sh"
    zsh_completion.install "shell/opam_completion_zsh.sh"
  end

  test do
    system "#{bin}/opam", "--help"
  end

  def caveats; <<-EOS.undent
    OPAM uses ~/.opam by default for its package database, so you need to
    initialize it first by running (as a normal user):

    $  opam init

    Run the following to initialize your environment variables:

    $  eval `opam config env`

    To export the needed variables every time, add them to your dotfiles.
      * On Bash, add them to `~/.bash_profile`.
      * On Zsh, add them to `~/.zprofile` instead.

    Documentation and tutorials are available at http://opam.ocaml.org, or
    via 'man opam' and 'opam --help'.
    EOS
  end
end
