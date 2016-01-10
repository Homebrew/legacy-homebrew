class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "http://ccl.clozure.com/"
  url "http://ccl.clozure.com/ftp/pub/release/1.11/ccl-1.11-darwinx86.tar.gz"
  version "1.11"
  sha256 "2fc4b519f26f7df3fbb62314b15bd5d098082b05d40c3539f8204aa10f546913"

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
