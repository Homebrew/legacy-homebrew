require 'formula'

class Coq < Formula
  url 'http://coq.inria.fr/distrib/V8.3pl1/files/coq-8.3pl1.tar.gz'
  version '8.3pl1'
  head 'svn://scm.gforge.inria.fr/svn/coq/trunk'
  homepage 'http://coq.inria.fr/'
  md5 '1869d22b337f5da59ba3bbe1433f9a3b'
  def patches
    # fixes configuration with explicit lablgtkdir
    'https://gist.github.com/raw/902986/702ed4bd71e354b7ebf252d2f00f984a93891664/coq-config.patch'
  end

  def options
    [
      ['--enable-gui', 'Build GTK+ gui']
    ]
  end

  skip_clean :all

  depends_on 'objective-caml'
  depends_on 'camlp5'

  if ARGV.include? '--enable-gui'
    depends_on 'lablgtk'
  end

  def install
    unless `camlp5 -pmode 2>&1`.chomp == 'transitional'
      onoe 'camlp5 must be compiled in transitional mode (--transitional option)'
      exit 1
    end
    if ARGV.include? '--enable-gui'
      lablgtk_lib = Formula.factory('lablgtk').lib+'ocaml/lablgtk2'
      ideflag = 'opt'
      configure_gui = ['-coqide', 'opt',
                       '-lablgtkdir', lablgtk_lib]
    else
      configure_gui = ['-coqide', 'none']
    end
    arch = Hardware.is_64_bit? ? "x86_64" : "i386"
    camlp5_lib = Formula.factory('camlp5').lib+'ocaml/camlp5'
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{lib}/emacs/site-lisp",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-with-doc", "no",
                          "-browser", "open '%s'",
                          "-arch", arch,
                          *configure_gui
    system "make world"
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Coq's Emacs mode is installed into
      #{lib}/emacs/site-lisp
    To use the Coq Emacs mode, you need to put the following lines in
    your .emacs file:

      (setq auto-mode-alist (cons '("\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
  end
end
