class Aften < Formula
  desc "Audio encoder which generates ATSC A/52 compressed audio streams"
  homepage "http://aften.sourceforge.net/"
  url "https://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2"
  sha256 "87cc847233bb92fbd5bed49e2cdd6932bb58504aeaefbfd20ecfbeb9532f0c0a"

  depends_on "cmake" => :build

  def install
    mkdir "default" do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
