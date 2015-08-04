class Csup < Formula
  desc "Rewrite of CVSup in C"
  homepage "https://bitbucket.org/mux/csup"
  url "https://bitbucket.org/mux/csup/get/REL_20120305.tar.gz"
  sha256 "6b9a8fa2d2e70d89b2780cbc3f93375915571497f59c77230d4233a27eef77ef"
  revision 1

  bottle do
    cellar :any
    sha256 "b034200ed85ed697a5989ab8aef518fb78024b57ef0cd1ecf7e21a9a3425f652" => :yosemite
    sha256 "ffa3d1bbc8fa67cf894b80094f2fa726772ddd602a77e32b403f0ceb8fb43c08" => :mavericks
    sha256 "83f4c2dda45961e164a267b9a20f64a2d5d60ddbf1f52305a6af6da1e49798fb" => :mountain_lion
  end

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
