require 'formula'

class Opam < Formula
  homepage 'https://opam.ocaml.org'
  url 'https://github.com/ocaml/opam/archive/1.2.1.tar.gz'
  sha1 'ec05bb766834c599ea5045eb3b7e92478ddf9dd0'

  head 'https://github.com/ocaml/opam.git'

  bottle do
    cellar :any
    sha256 "07bb172ee9fe261c4216b94f9fbb6e7789394ae0aa2baaf5edfb7531f31a557a" => :yosemite
    sha256 "295c0f30bf07605c585810fcd0dd1c767defb5353f681d69a390f518f722a3d4" => :mavericks
    sha256 "00971c8f7ead433bdac2731715380aef7635847c8f899be6dcf08a9d6d162455" => :mountain_lion
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
    url "https://gforge.inria.fr/frs/download.php/file/34277/dose3-3.3.tar.gz"
    sha1 "889b1d7daf963ab21b2c06e68ea8c3f51b58960d"
  end

  resource "cmdliner" do
    url "http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.7.tbz"
    sha1 "7eb50ddb16a1e58bf39755117193a53a7613042c"
  end

  resource "uutf" do
    url "http://erratique.ch/software/uutf/releases/uutf-0.9.3.tbz"
    sha1 "9f9ae5a16ff0cd7ffeebf8b4174c5f041739b231"
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
