class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "http://sourceforge.net/projects/bsponmpi"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"

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
