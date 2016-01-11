class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  head "https://github.com/rkitover/vimpager.git"

  option "with-pandoc", "Use pandoc to build and install man pages"
  depends_on "pandoc" => [:build, :optional]

  def install
    system "make", "docs" if build.with? "pandoc"
    bin.install "vimcat"
    bin.install "vimpager"
    doc.install "README.md", "vimcat.md", "vimpager.md"
    man1.install "vimcat.1", "vimpager.1" if build.with? "pandoc"
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/vimcat test.txt"))
  end
end
