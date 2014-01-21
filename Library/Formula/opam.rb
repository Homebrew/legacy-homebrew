require 'formula'

class Opam < Formula
  homepage 'https://opam.ocaml.org'
  url 'https://github.com/ocaml/opam/archive/1.1.1.tar.gz'
  sha1 'f1a8291eb888bfae4476ee59984c9a30106cd483'

  head 'https://github.com/ocaml/opam.git'

  depends_on "objective-caml"
  depends_on "aspcud" => :recommended

  if build.with? "aspcud"
    needs :cxx11
  end

  resource "cudf" do
    url "https://gforge.inria.fr/frs/download.php/31910/cudf-0.6.3.tar.gz"
    sha1 "e2699dd33b8c49d8122c4402a20561a4dfdd1bae"
  end

  resource "extlib" do
    url "http://ocaml-extlib.googlecode.com/files/extlib-1.5.3.tar.gz"
    sha1 "6e395ae70e690d5ec6f166cce4761798ce494580"
  end

  resource "ocaml-re" do
    url "https://github.com/ocaml/ocaml-re/archive/ocaml-re-1.2.0.tar.gz"
    sha1 "d54439efaaf888d619cbf1ccd92fbb077aed5d6a"
  end

  resource "ocamlgraph" do
    url "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.1.tar.gz"
    sha1 "1eac55604956f566f525c3e043188d626d1924ce"
  end

  resource "dose3" do
    url "https://gforge.inria.fr/frs/download.php/31595/dose3-3.1.2.tar.gz"
    sha1 "c1033921e907a1cfa7a8873683b0debe24319f87"
  end

  resource "cmdliner" do
    url "http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.3.tbz"
    sha1 "af7e32e5f2eb829aab9ba6c1d85574b2a3ba174e"
  end

  def install
    ENV.deparallelize
    # Set TERM to workaround bug in ocp-build (ocaml/opam#1038)
    ENV["TERM"] = "dumb"

    # We put the compressed external libraries where the build
    # expects to find them, thus tricking it into believing that it
    # already downloaded the necessary files.
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      original_name = r.cached_download.basename.sub(/^#{Regexp.escape(name)}--/, "")
      cp r.cached_download, buildpath/"src_ext/#{original_name}"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "shell/opam_completion.sh"
    zsh_completion.install "shell/opam_completion_zsh.sh" => "_opam"
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
