class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
  sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  option "with-elisp", "Include Emacs lisp package"

  depends_on "llvm" => "with-clang"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.diff"
    sha256 "6f638c473781a8f86a0ab970303579256f49882744863e36924748c010e7c1ed"
  end

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
