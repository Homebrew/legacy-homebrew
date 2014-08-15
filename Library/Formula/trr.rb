require "formula"

class Trr < Formula
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  sha1 "17082cc5fcebb8c877e6a17f87800fecc3940f24"
  version "22.0.99.5"

  depends_on "apel"
  depends_on "nkf" => :build

  def install
    system "make", "clean"
    cp Dir["#{Formula['apel'].share}/emacs/site-lisp/*"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", "#{buildpath}/CONTENTS"

    system "make", "all"
    system "make", "install", "LISPDIR=#{share}/emacs/site-lisp",
                              "TRRDIR=#{prefix}",
                              "INFODIR=#{info}"
    touch "#{prefix}/record/SCORES-IC"
  end

  def caveats; <<-EOF.undent
    Add below to your emacs configuration file. (ex. ~/emacs.d/init.el)

    (add-to-list 'load-path "#{Formula['apel'].share}/emacs/site-lisp")
    (add-to-list 'load-path "#{share}/emacs/site-lisp")
    (autoload 'trr "#{share}/emacs/site-lisp/trr" nil t)

    EOF
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{Formula['apel'].share}/emacs/site-lisp")
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'trr)
      (setq TRR:japanese nil)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -batch -l #{program}").strip
  end

end
