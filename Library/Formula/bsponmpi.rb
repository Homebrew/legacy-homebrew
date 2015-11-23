class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"

  bottle do
    sha256 "5a5ab6a124590499808d601b0b7cdca8ba661b33540a0d09de76172d795fa28c" => :el_capitan
    sha256 "327737da76860b7954ba14bf4abb90f4647432c065069bdc968ef5860a5ae7fe" => :yosemite
    sha256 "9656ddf73df0162b8d35368c6db97df996343d83a03471866e461529dba5e424" => :mavericks
  end

  depends_on "scons" => :build
  depends_on :mpi => [:cc, :cxx]

  def install
    # Don't install 'CVS' folders from tarball
    rm_rf "include/CVS"
    rm_rf "include/tools/CVS"
    scons "-Q", "mode=release"
    prefix.install "lib", "include"
  end
end
