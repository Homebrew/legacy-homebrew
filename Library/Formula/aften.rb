class Aften < Formula
  desc "Audio encoder which generates ATSC A/52 compressed audio streams"
  homepage "http://aften.sourceforge.net/"
  url "https://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2"
  sha256 "87cc847233bb92fbd5bed49e2cdd6932bb58504aeaefbfd20ecfbeb9532f0c0a"

  bottle do
    cellar :any
    sha256 "68b4983cc843e2d57854a263038a965a2dd6c473c98111f482ec1c69d09ace83" => :el_capitan
    sha256 "4f785f04a3bbde677452f2c5d1c04f77605e156b4020294c5799c85d0b8586d3" => :yosemite
    sha256 "b7acaf77ece8e6b51493ce69e713990a4ce13bc5b9d5ad6914cc86c0f745c9d0" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "default" do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
