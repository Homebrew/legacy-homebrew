require 'formula'

class EmacsClangCompleteAsync < Formula
  homepage 'https://github.com/Golevka/emacs-clang-complete-async'
  url 'https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz'
  sha1 '7f50d3029fedee5ef9306afdac547571928a16b4'

  head 'https://github.com/Golevka/emacs-clang-complete-async.git'

  option 'with-elisp', 'Include Emacs lisp package'

  depends_on 'llvm' => 'with-clang'

  # https://github.com/Golevka/emacs-clang-complete-async/issues/65
  patch :DATA

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el" if build.with? "elisp"
  end
end

__END__
--- a/src/completion.h	2013-05-26 17:27:46.000000000 +0200
+++ b/src/completion.h	2014-02-11 21:40:18.000000000 +0100
@@ -3,6 +3,7 @@


 #include <clang-c/Index.h>
+#include <stdio.h>


 typedef struct __completion_Session_struct
