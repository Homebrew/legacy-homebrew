require "formula"

class Itpp < Formula
  homepage "http://itpp.sourceforge.net"
  head "http://git.code.sf.net/p/itpp/git"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha1 "955784bcfb61481e47d8c788a62cea8d78d175cb"

  depends_on "cmake" => :build
  depends_on "fftw" => :recommended

  def install
    mkdir 'build' do
      args = std_cmake_args
      args.delete '-DCMAKE_BUILD_TYPE=None'
      args << '-DCMAKE_BUILD_TYPE=Release'
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
