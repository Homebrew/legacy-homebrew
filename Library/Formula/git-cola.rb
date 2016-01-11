class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.4.tar.gz"
  sha256 "ef735431a2e58bac7671c4b9ab4fbb369195b16987fe9d3d931a9097c06c7f36"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d9b0f0b7df97b5e37fdf2b548f297aca05d303b4b27e66a81bd2972a9164163" => :el_capitan
    sha256 "0e307cb96047b9448bc531188fb8f44831074647a95819d5de76c59b4c4fb9fa" => :yosemite
    sha256 "3c1cde2b3b70661603f9eb94d3d0560ceaf27b11b98edb2b68b3bf524c444751" => :mavericks
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    system "make", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "install-doc", "prefix=#{prefix}",
             "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
