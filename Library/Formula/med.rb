class Med < Formula
  desc "Model for Exchange of Data. Data exchange system for numerical models"
  homepage "http://www.salome-platform.org/user-section/about/med"
  url "http://files.salome-platform.org/Salome/other/med-3.0.8.tar.gz"
  sha256 "0f97e9b5ae514aa53f4c0507f1002a3f520c3b959e756c38cfd9cae4a31a0689"

  depends_on "cmake" => :build
  depends_on "hdf5" => "with-mpi"
  depends_on :mpi
  depends_on :python

  def install
    system "cmake", ".", *std_cmake_args, "-DMEDFILE_BUILD_TESTS:BOOL=OFF"
    system "make", "install"
  end

  test do
    system "false"
  end
end
