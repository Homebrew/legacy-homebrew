class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.2.1.tar.gz"
  sha256 "7c7ecd23d4b0be5255d4ddbcba14b03ec6adf9d38e0e393d6190787621e66952"

  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any
    sha256 "3bca80e05819e5f779ca39880fdadb0f3373ae03532e3a116d22bd49b7266227" => :yosemite
    sha256 "ff2b8f6fe94c84bdc490a8c5f8d63fbfd64fd79783109be96e0e58adc8805bdb" => :mavericks
    sha256 "257bfba15d83cb174afafd30d221aaa5134d7c5640b1dbc44d811587997c9073" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "snappy"
  depends_on "boost" => :optional

  def install
    args = std_cmake_args + %w[. -DBUILD_TESTS=ON]
    args << "-DWITH_BOOST_IOSTREAMS=1" if build.with? "boost"
    system "cmake", *args
    system "make", "all", "test", "install"
  end

  test do
    (testpath/"testsnappystream.cxx").write <<-EOS.undent
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
    EOS
    system ENV.cxx, "testsnappystream.cxx", "-lsnappy", "-lsnappystream", "-o", "testsnappystream"
    system "./testsnappystream < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
