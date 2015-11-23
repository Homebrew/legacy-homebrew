class Trr < Formula
  desc "Type training program for emacs users"
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  version "22.0.99.5"
  sha256 "6bac2f947839cebde626cdaab0c0879de8f6f6e40bfd7a14ccdfe1a035a3bcc6"
  revision 1

  bottle do
    sha256 "b965ca412e2a97b20bda8afb03fb042fe05f162c6391ea5460e05473c9260ced" => :yosemite
    sha256 "1b24783f3b7060b6c1ac0a9edac5a990fc2bcefcccef9746897a627c912a931f" => :mavericks
    sha256 "2373aaab80559228b2d5510494ba23f22fa6527d6e906ce4c7c6dbc6ff8a9ce4" => :mountain_lion
  end

  depends_on "apel"
  depends_on "nkf" => :build

  def install
    system "make", "clean"
    cp Dir["#{Formula["apel"].share}/emacs/site-lisp/apel/**/*.el"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", "#{buildpath}/CONTENTS"

    # wrong text filename
    inreplace "#{buildpath}/CONTENTS", "EmacsLisp", "Elisp_programs"

    system "make", "clean"
    cp Dir["#{Formula["apel"].share}/emacs/site-lisp/apel/**/*.elc"], buildpath

    # texts for playing trr
    texts = "The_Constitution_Of_JAPAN Constitution_of_the_USA Iccad_90 C_programs Elisp_programs Java_programs Ocaml_programs Python_programs"

    inreplace "#{buildpath}/Makefile", "japanese = t", "japanese = nil"

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "TRRDIR=#{prefix}",
                   "INFODIR=#{info}",
                   "BINDIR=#{bin}",
                   "TEXTS=#{texts}",
                   "LISPDIR=#{share}/emacs/site-lisp/trr"
    (prefix/"record").install Dir["record/*"]
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/apel/emu")
      (add-to-list 'load-path "#{share}/emacs/site-lisp/trr")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
