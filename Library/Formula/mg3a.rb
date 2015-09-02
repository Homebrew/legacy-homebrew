class Mg3a < Formula
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.150703.tar.gz"
  sha256 "c1e0dec1b2ba1feebc623f5a032653dcab442ef9438449ec556166de504d7a0b"

  conflicts_with "mg", :because => "both install `mg`"

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  def install
    mg3aopts=" -DDIRED -DPREFIXREGION -DUSER_MODES -DUSER_MACROS"
    mg3aopts << " -DLANGMODE_C" if build.with?("c-mode")
    mg3aopts << " -DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
    mg3aopts << " -DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    mg3aopts = "-DALL" if build.with?("all")
    mg3aopts << " -DEMACS_QUIT"

    system "make", "CDEFS=#{mg3aopts}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end
  test do
    system "mg", "-e", "save-buffers-kill-emacs"
  end
end
