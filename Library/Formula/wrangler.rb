class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "http://www.cs.kent.ac.uk/projects/forse/"
  url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.1.01.tar.gz"
  sha256 "e61c13ec772e137efdcf5aa8f21210ef424eac3ee2b918efe5e456985bb19626"

  depends_on "erlang"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
