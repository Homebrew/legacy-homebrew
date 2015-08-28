class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.3.tar.gz"
  sha256 "3319810c16f6864deb5f94f533c7cfd17f30961595454da7c3c75879f56511b3"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha256 "62e8ac62b5281dc299a7a1042f41bdf60e3a6b796a2c1bfd55cbfc2d6364b708" => :yosemite
    sha256 "b464caa7c1520561e0fd97afcd83faa6f81789c28108dacf0c25fed026dd1fc7" => :mavericks
    sha256 "b67df2e41d37a3226d4e5a5819c1c9a33cc02bf08cee321e10897ea198fde086" => :mountain_lion
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
