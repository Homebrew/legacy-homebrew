require "formula"

class Snappystream < Formula
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.1.2.tar.gz"
  sha1 "40ceac66a58659d1827cc7375a72210bb84be9b3"

  head "https://github.com/hoxnox/snappystream.git"

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    args = std_cmake_args + %W[ -DBUILD_TESTS=ON ]

    system "cmake", ".", *args
    system "make", "all", "test", "install"
  end

  test do
    (testpath/"testsnappystream.cxx").write <<-EOF
#include <iostream>
#include <fstream>
#include <iterator>
#include <algorithm>
#include <snappystream.hpp>

int main()
{
  { std::ofstream ofile("snappy-file.dat");
    snappy::oSnappyStream osnstrm(ofile);
    std::cin >> std::noskipws;
    std::copy(std::istream_iterator<char>(std::cin), std::istream_iterator<char>(), std::ostream_iterator<char>(osnstrm));
  }
  { std::ifstream ifile("snappy-file.dat");
    snappy::iSnappyStream isnstrm(ifile);
    isnstrm >> std::noskipws;
    std::copy(std::istream_iterator<char>(isnstrm), std::istream_iterator<char>(), std::ostream_iterator<char>(std::cout));
  }
}
EOF
    system ENV.cxx, "testsnappystream.cxx", "-lsnappy", "-lsnappystream", "-o", "testsnappystream"
    assert $?.success?
    system "./testsnappystream < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
    assert $?.success?
  end
end
