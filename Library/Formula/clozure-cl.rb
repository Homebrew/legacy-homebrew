class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "http://ccl.clozure.com/"
  url "http://ccl.clozure.com/ftp/pub/release/1.10/ccl-1.10-darwinx86.tar.gz"
  version "1.10"
  sha256 "5ec70087e6ba54e1992210575d444ebb2e12dbd33ac2816fed1112d24d595ec9"

  bottle :unneeded

  conflicts_with "cclive", :because => "both install a ccl binary"

  def install
    # Get rid of all the .svn directories
    rm_rf Dir["**/.svn"]

    libexec.install Dir["*"]
    scripts = Dir["#{libexec}/scripts/ccl{,64}"]

    inreplace scripts, /CCL_DEFAULT_DIRECTORY=.+$/, %(CCL_DEFAULT_DIRECTORY="#{libexec}")
    bin.install_symlink scripts
  end

  def test_ccl(bit = 32)
    ccl = bin + "ccl#{"64" if bit == 64}"
    %{#{ccl} -e '(progn (format t "Hello world from #{bit}-bit ClozureCL") (ccl::quit))'}
  end

  test do
    system test_ccl
    system test_ccl(64)
  end
end
