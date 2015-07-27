class Mg3a < Formula
  desc "Small Emacs-like editor with UTF-8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.150703.tar.gz"
  sha256 "c1e0dec1b2ba1feebc623f5a032653dcab442ef9438449ec556166de504d7a0b"

  conflicts_with "mg", :because => "both install `mg`"

  option "without-emacs-quit", "Use ^U ^X ^C to exit saving"
  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "without-dired", "Exclude dired functions"
  option "without-prefix-region", "Exclude the prefix region mode"
  option "with-user-modes", "Include the support for user defined modes"
  option "with-user-macros", "Include the support for user defined macros"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  def install
    mg3aopts=""
    mg3aopts << " -DDIRED" if build.with?("dired") || build.with?("most")
    mg3aopts << " -DPREFIXREGION" if build.with?("prefix-region") || build.with?("most")
    mg3aopts << " -DLANGMODE_C" if build.with?("c-mode")
    mg3aopts << " -DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
    mg3aopts << " -DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    mg3aopts << " -DUSER_MODES" if build.with?("user-modes") || build.with?("most")
    mg3aopts << " -DUSER_MACROS" if build.with?("user-macros") || build.with?("most")
    mg3aopts = "-DALL" if build.with?("all")
    mg3aopts << " -DEMACS_QUIT" if build.with?("emacs-quit")

    system "make", "CDEFS=#{mg3aopts}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end
  test do
    system "mg", "-e", "save-buffers-kill-emacs"
  end
end
