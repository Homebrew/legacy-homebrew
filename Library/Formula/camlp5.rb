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
    revision 1
    sha256 "9a2321af5082525322937a17a66fc75d8a7ccb94eb74099ddc33ceb8d1dbad0c" => :el_capitan
    sha256 "c0edde4ff0551c6e626adc73189959fbdb4342aafe9ae8fe9b41946254c0f322" => :yosemite
    sha256 "2ee8251c85a5860982063b9c1c3ed554c25410eb884aa35ade2a6a82866998c9" => :mavericks
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
