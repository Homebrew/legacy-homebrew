require 'formula'

class Opam < Formula
  homepage 'https://opam.ocaml.org'
  url 'https://github.com/ocaml/opam/archive/1.1.0.tar.gz'
  sha1 'fe66f5cfc9ffe9f621462e52e17cbb5869de419a'

  head 'https://github.com/ocaml/opam.git'

  depends_on "objective-caml"

  resource 'cudf' do
    url 'https://gforge.inria.fr/frs/download.php/31910/cudf-0.6.3.tar.gz'
    md5 '40c4e2c50ea96d0c9e565db16d20639a'
  end

  resource 'extlib' do
    url 'http://ocaml-extlib.googlecode.com/files/extlib-1.5.3.tar.gz'
    md5 '3de5f4e0a95fda7b2f3819c4a655b17c'
  end

  resource 'ocaml-re' do
    url 'https://github.com/ocaml/ocaml-re/archive/ocaml-re-1.2.0.tar.gz'
    md5 '5cbfc137683ef2b0e91f931577f2e673'
  end

  resource 'ocamlgraph' do
    url 'http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.1.tar.gz'
    md5 '5aa256e9587a6d264d189418230af698'
  end

  resource 'dose3' do
    url 'https://gforge.inria.fr/frs/download.php/31595/dose3-3.1.2.tar.gz'
    md5 'e98ff720fcc3873def46c85c6a980a1b'
  end

  resource 'cmdliner' do
    url 'http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.3.tbz'
    md5 'd63dd3b03966d65fc242246859c831c7'
  end

  def install
    ENV.deparallelize

    # We put the compressed external libraries where the build
    # expects to find them, thus tricking it into believing that it
    # already downloaded the necessary files.
    resources.each do |r|
      formula_name = Regexp.escape(name)
      original_name = r.cached_download.basename.sub /^#{formula_name}--/, ''
      r.cached_download.cp buildpath/"src_ext/#{original_name}"
    end

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
