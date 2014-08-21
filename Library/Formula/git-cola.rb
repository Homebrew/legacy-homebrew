require "formula"

class GitCola < Formula
  homepage "http://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.0.5.tar.gz"
  sha1 "530bb6956d0499f0451979eaeee65e6a2298d30b"

  head "https://github.com/git-cola/git-cola.git"

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
