class Fstar < Formula
  desc "Language with a type system for program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
    :tag => "0.9.2.0",
    :revision => "658799a67706b635c5c42498fb42c21cf126e56e"
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07876ce2eea2d7c3ab99f3aa8babbc51e97bf7c3e5a95e8f031046b2b33ad3d1" => :el_capitan
    sha256 "f463732649500403aea50647b9a2f9e73530b3e6b541442f0491f8034ffba10a" => :yosemite
    sha256 "d81ab524ccbb6d0735fa99b19c3536f02813a4b2cf87ebe138df40c44a0cb1cf" => :mavericks
  end

  depends_on "mono" => :build
  depends_on "opam" => :build
  depends_on "ocaml" => :recommended
  depends_on "z3" => :recommended

  resource "ocamlfind" do
    url "http://download.camlcity.org/download/findlib-1.5.5.tar.gz"
    sha256 "aafaba4f7453c38347ff5269c6fd4f4c243ae2bceeeb5e10b9dab89329905946"
  end

  resource "batteries" do
    url "https://github.com/ocaml-batteries-team/batteries-included/archive/v2.4.0.tar.gz"
    sha256 "f13ff15efa35c272e1e63a2604f92c1823d5685cd73d3d6cf00f25f80178439f"
  end

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    archives = opamroot/"repo/default/archives"
    modules = []
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      original_name = File.basename(r.url)
      cp r.cached_download, archives/original_name
      modules << "#{r.name}=#{r.version}"
    end
    system "opam", "install", *modules

    system "make", "-C", "src/"
    system "opam", "config", "exec", "--",
    "make", "-C", "src/ocaml-output/"

    bin.install "src/ocaml-output/fstar.exe"

    (libexec/"stdlib").install Dir["lib/*"]
    (libexec/"contrib").install Dir["contrib/*"]
    (libexec/"examples").install Dir["examples/*"]
    (libexec/"tutorial").install Dir["doc/tutorial/*"]
    (libexec/"src").install Dir["src/*"]
    (libexec/"licenses").install "LICENSE-fsharp.txt", Dir["3rdparty/licenses/*"]

    prefix.install_symlink libexec/"stdlib"
    prefix.install_symlink libexec/"contrib"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"tutorial"
    prefix.install_symlink libexec/"src"
    prefix.install_symlink libexec/"licenses"
  end

  def caveats; <<-EOS.undent
    F* standard library is available in #{prefix}/stdlib:
    - alias fstar='fstar.exe --include #{prefix}/stdlib --prims prims.fst'

    F* code can be extracted to OCaml code.
    To compile the generated OCaml code, you must install the
    package 'batteries' from the Opam package manager:
    - brew install opam
    - opam install batteries

    F* code can be extracted to F# code.
    To compile the generated F# (.NET) code, you must install
    Mono and the FSharp compilers:
    - brew install mono
    EOS
  end

  test do
    system "#{bin}/fstar.exe",
    "--include", "#{prefix}/stdlib",
    "--include", "#{prefix}/examples/unit-tests",
    "--admit_fsi", "FStar.Set",
    "FStar.Set.fsi", "FStar.Heap.fst",
    "FStar.ST.fst", "FStar.All.fst",
    "FStar.List.fst", "FStar.String.fst",
    "FStar.Int32.fst", "unit1.fst",
    "unit2.fst", "testset.fst"
  end
end
