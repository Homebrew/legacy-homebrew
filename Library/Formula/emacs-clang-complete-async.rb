require 'formula'

class EmacsClangCompleteAsync < Formula
  homepage 'https://github.com/Golevka/emacs-clang-complete-async'
  url 'https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.zip'
  sha1 'a95ad0d2336548a41049358cac4c1dfb29561349'

  head 'https://github.com/Golevka/emacs-clang-complete-async.git'

  option 'with-elisp', 'Include Emacs lisp package'

  depends_on 'llvm' => 'with-clang'

  # https://github.com/Golevka/emacs-clang-complete-async/issues/65
  def patches; DATA; end

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el" if build.include? 'with-elisp'
  end
end

__END__
--- a/src/completion.h	2013-05-26 17:27:46.000000000 +0200
+++ b/src/completion.h	2014-02-11 21:40:18.000000000 +0100
@@ -3,6 +3,7 @@
 
 
 #include <clang-c/Index.h>
+#include <stdio.h>
 
 
 typedef struct __completion_Session_struct
