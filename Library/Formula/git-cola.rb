class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.3.tar.gz"
  sha256 "3319810c16f6864deb5f94f533c7cfd17f30961595454da7c3c75879f56511b3"

  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "844c8eebab249212800e996ae3130049823238ffecd28545b37020bb06f0c5b9" => :el_capitan
    sha256 "fa89698f2a4b30a95ea75d9ceff7075b908dce9180f08d4612dd4265b77b91ab" => :yosemite
    sha256 "fbb533d16e29f44da27ad628043c483e575ab022ac27fed2730d56cc3bbfffe3" => :mavericks
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
