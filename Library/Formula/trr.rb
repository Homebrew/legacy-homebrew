class Trr < Formula
  desc "Type training program for emacs users"
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  version "22.0.99.5"
  sha256 "6bac2f947839cebde626cdaab0c0879de8f6f6e40bfd7a14ccdfe1a035a3bcc6"

  bottle do
    sha256 "9db1d6af43f8797b99e098261a16288b34da8f137135b218b1ceb156544c283b" => :yosemite
    sha256 "64140988ac10d12d10db976cc6e598b7aef23cb81eceed5007536023adf0af72" => :mavericks
    sha256 "0b48f5995fb731eca7ecf381f27d6d3f83e2995508b026c8336bb7d583323a03" => :mountain_lion
  end

  depends_on "apel"
  depends_on "nkf" => :build

  def install
    system "make", "clean"
    cp Dir["#{Formula["apel"].share}/emacs/site-lisp/*"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", "#{buildpath}/CONTENTS"

    # wrong text filename
    inreplace "#{buildpath}/CONTENTS", "EmacsLisp", "Elisp_programs"

    system "make", "clean"
    cp Dir["#{Formula["apel"].share}/emacs/site-lisp/*.elc"], buildpath

    # texts for playing trr
    texts = "The_Constitution_Of_JAPAN Constitution_of_the_USA Iccad_90 C_programs Elisp_programs Java_programs Ocaml_programs Python_programs"

    inreplace "#{buildpath}/Makefile", "japanese = t", "japanese = nil"
    system "make", "all", "LISPDIR=#{share}/emacs/site-lisp",
                          "TRRDIR=#{prefix}",
                          "INFODIR=#{info}",
                          "BINDIR=#{bin}",
                          "TEXTS=#{texts}"
    system "make", "install", "LISPDIR=#{share}/emacs/site-lisp",
                              "TRRDIR=#{prefix}",
                              "INFODIR=#{info}",
                              "BINDIR=#{bin}",
                              "TEXTS=#{texts}"
    cp Dir["record/*"], "#{prefix}/record/"
  end

  def caveats; <<-EOF.undent
    Please add below lines to your emacs configuration file. (ex. ~/emacs.d/init.el)
    (add-to-list 'load-path "#{Formula["apel"].share}/emacs/site-lisp")
    (add-to-list 'load-path "#{share}/emacs/site-lisp")
    (autoload 'trr "#{share}/emacs/site-lisp/trr" nil t)
    EOF
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["apel"].share}/emacs/site-lisp")
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -batch -l #{program}").strip
  end
end
