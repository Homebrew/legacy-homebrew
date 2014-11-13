require 'formula'

class Opam < Formula
  homepage 'https://opam.ocaml.org'
  url 'https://github.com/ocaml/opam/archive/1.2.0.tar.gz'
  sha1 'b7923516a853afe86e8439afd23c0dae5fa8ad57'
  revision 1

  head 'https://github.com/ocaml/opam.git'

  bottle do
    cellar :any
    sha1 "a6cd98098c152c20b8e80921e909c8b2e199c395" => :yosemite
    sha1 "eca0fd67eaf6f6e40512442ae2dec61a4acd6f4d" => :mavericks
    sha1 "18160a6ea74da457dbbb2b54370b8b9bd83bdfb2" => :mountain_lion
  end

  depends_on "objective-caml"
  depends_on "camlp4" => :recommended

  # aspcud has a fairly large buildtime dep tree, and uses gringo,
  # which requires C++11 and is inconvenient to install pre-10.8
  if MacOS.version > 10.7
    depends_on "aspcud" => :recommended
  else
    depends_on "aspcud" => :optional
  end

  if build.with? "aspcud"
    needs :cxx11
  end

  resource "cudf" do
    url "https://gforge.inria.fr/frs/download.php/file/33593/cudf-0.7.tar.gz"
    sha1 "33d6942caf5f008d6696c1200a2589e28ff7e7fa"
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
    url "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.5.tar.gz"
    sha1 "e53a92d50685ab38f2b856eb64d93aa36dc7bcdf"
  end

  resource "dose3" do
    url "https://gforge.inria.fr/frs/download.php/file/33677/dose3-3.2.2.tar.gz"
    sha1 "9e679404f46dd0c9af4c6b77d6088b17986741b3"
  end

  resource "cmdliner" do
    url "http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.4.tbz"
    sha1 "afa604e527fc3e0753c643a96c354d4a6421321c"
  end

  resource "jsonm" do
    url "http://erratique.ch/software/jsonm/releases/jsonm-0.9.1.tbz"
    sha1 "733fe089fb91ac79ac885e9c80d5554aca3e7805"
  end

  def install
    ENV.deparallelize

    # We put the compressed external libraries where the build
    # expects to find them, thus tricking it into believing that it
    # already downloaded the necessary files.
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      original_name = r.cached_download.basename.sub(/^#{Regexp.escape(name)}--/, "")
      cp r.cached_download, buildpath/"src_ext/#{original_name}"
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "man"
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

    Documentation and tutorials are available at https://opam.ocaml.org, or
    via 'man opam' and 'opam --help'.
    EOS
  end
end
