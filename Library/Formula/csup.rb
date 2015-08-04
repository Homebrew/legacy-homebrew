class Csup < Formula
  desc "Rewrite of CVSup in C"
  homepage "https://bitbucket.org/mux/csup"
  url "https://bitbucket.org/mux/csup/get/REL_20120305.tar.gz"
  sha256 "6b9a8fa2d2e70d89b2780cbc3f93375915571497f59c77230d4233a27eef77ef"
  revision 1

  head "https://bitbucket.org/mux/csup", :using => :hg

  depends_on "openssl"

  def install
    system "make"
    bin.install "csup"
    man1.install "csup.1"
  end

  test do
    system "#{bin}/csup", "-v"
  end
end
