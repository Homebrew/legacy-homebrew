class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "http://itpp.sourceforge.net"
  head "http://git.code.sf.net/p/itpp/git"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"

  depends_on "cmake" => :build
  depends_on "fftw" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args.delete "-DCMAKE_BUILD_TYPE=None"
      args << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end
