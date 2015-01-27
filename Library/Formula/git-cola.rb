class GitCola < Formula
  homepage "http://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.1.0.tar.gz"
  sha1 "c93e74b021e6e5df92a46a3d05ac8a6377571fa8"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha1 "bc3a197d229a4dbcefb593ee8ee0453d87eb7e8f" => :yosemite
    sha1 "13d367b370dd4d0593e78608394eb381987b9847" => :mavericks
    sha1 "4f1c8150aeb4273789527251e7c042152ed243d5" => :mountain_lion
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
