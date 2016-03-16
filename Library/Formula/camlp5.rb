class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.15.tgz"
  mirror "https://ftp.ucsb.edu/pub/mirrors/linux/gentoo/distfiles/camlp5-6.15.tgz"
  mirror "https://mirror.csclub.uwaterloo.ca/gentoo-distfiles/distfiles/camlp5-6.15.tgz"
  mirror "https://mirror.netcologne.de/gentoo/distfiles/camlp5-6.15.tgz"
  sha256 "2e0e1e31e0537f2179766820dd9bd0a4d424bc5ab9c610e6dbf9145f27747f2b"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "90a523e4dc28c340ccec3e2aa7b2ef37a9534c6cb47f92396c7a7e12b0ba1b85" => :el_capitan
    sha256 "d512ce25f65960cfe8edc96eb13a9577bea6b4156d2b60a7e95ba6da322c4a88" => :yosemite
    sha256 "48b7eee6bd396c3cbfb1ad54213ddafd273754192257253f30426a95f6a8e7ce" => :mavericks
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"
  option "with-tex", "Install the pdf, ps, and tex documentation"
  option "with-doc", "Install the html and info documentation"

  depends_on "ocaml"
  depends_on :tex => [:build, :optional]
  depends_on "ghostscript" => :build if build.with?("tex")
  depends_on "gnu-sed" => :build if build.with?("doc") || build.with?("tex")

  def install
    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"

    if build.with?("doc") || build.with?("tex")
      ENV.deparallelize
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      cd "doc/htmlp"
      if build.with? "doc"
        system "make" # outputs the html version of the docs in ../html
        system "make", "info"
        doc.install "../html", Dir["camlp5.info*"]
      end
      if build.with? "tex"
        inreplace "Makefile", "ps2pdf", Formula["ghostscript"].opt_bin/"ps2pdf"
        system "make", "tex", "ps", "pdf"
        doc.install "camlp5.tex", "camlp5.ps", "camlp5.pdf"
      end
    end
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
