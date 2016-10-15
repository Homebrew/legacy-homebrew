class ClangFormatVim < Formula
  desc "Minimal clang-format vim-integration"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  url "https://llvm.org/svn/llvm-project/cfe/trunk/tools/clang-format/clang-format.py"
  sha256 "923bf2fffe0c8f6104e200a9fb2edabe28f14ba5c2e25ef871e0d1cb4ac279d9"

  depends_on "clang-format"
  depends_on "vim" => [:optional, "with-python"]
  depends_on "macvim" => [:optional, "with-python"]

  def install
    share.install "clang-format.py"
  end
end
