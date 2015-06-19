class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.04.tar.gz"
  sha256 "eefbfe178ea03be3df8bbad82ba162797ab8fb49c994b4b240d513cd0c3ef3f0"
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
end
