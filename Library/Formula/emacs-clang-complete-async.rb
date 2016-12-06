require 'formula'

class EmacsClangCompleteAsync < Formula
  homepage 'https://github.com/Golevka/emacs-clang-complete-async'
  url 'https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.zip'
  sha1 'a95ad0d2336548a41049358cac4c1dfb29561349'

  head 'https://github.com/Golevka/emacs-clang-complete-async.git'

  option 'with-elisp', 'Include Emacs lisp package'

  depends_on 'llvm' => 'with-clang'

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el" if build.include? 'with-elisp'
  end
end
