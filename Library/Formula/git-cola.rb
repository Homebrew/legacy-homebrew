class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "http://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.1.0.tar.gz"
  sha1 "c93e74b021e6e5df92a46a3d05ac8a6377571fa8"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha1 "fc7b0c0eeed41bb42764a25b8b229f39b3dc4fb3" => :yosemite
    sha1 "1f7e728856585487951f48b9e612cf628e112ac8" => :mavericks
    sha1 "864bafa798ff86c6213238a6c9922549aee94a95" => :mountain_lion
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  depends_on "pyqt"

  if build.with? "docs"
    # these are needed to build man pages
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  def install
    system "make", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "-C", "share/doc/git-cola",
                     "-f", "Makefile.asciidoc",
                     "prefix=#{prefix}",
                     "install", "install-html"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
