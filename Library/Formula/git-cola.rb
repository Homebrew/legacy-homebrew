require "formula"

class GitCola < Formula
  homepage "http://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.0.5.tar.gz"
  sha1 "530bb6956d0499f0451979eaeee65e6a2298d30b"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any
    sha1 "f2acd531c892f811c317630db8b66c4b398d24e2" => :mavericks
    sha1 "87825694c73263eba4429a2e3f8792dbd4fd4bad" => :mountain_lion
    sha1 "69d5577b80e332a6f97aef0394ecf21fb003991b" => :lion
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

end
