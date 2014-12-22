class GitCola < Formula
  homepage "http://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.0.8.tar.gz"
  sha1 "38db3432ca90047448c8f3b6f20ef0ad37c15fa1"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any
    sha1 "3d25d2a75de62577e8e9a681657fa2f5403c26c9" => :mavericks
    sha1 "ee451c446b61864a44347d2f544c62a49bb021f1" => :mountain_lion
    sha1 "88e4243fb3c9ee15465825c70a388235904c9f06" => :lion
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
