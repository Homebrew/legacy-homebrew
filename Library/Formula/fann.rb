require 'formula'

class Fann < Formula
  homepage 'http://leenissen.dk/fann/wp/'
  url 'http://downloads.sourceforge.net/project/fann/fann/2.2.0/FANN-2.2.0-Source.tar.gz'
  md5 'c9d6c8da5bb70276352a1718a668562c'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
