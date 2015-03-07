class Snappystream < Formula
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.1.2.tar.gz"
  sha1 "40ceac66a58659d1827cc7375a72210bb84be9b3"

  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any
    sha1 "91ab0e9f503246dc9f9ffaf988c277b1c8799b79" => :yosemite
    sha1 "8b18651bcb5fbfd4ffd221300883a96759bc093f" => :mavericks
    sha1 "37d9572034e5d3227401cd3688c586f790691196" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    system "cmake", ".", "-DBUILD_TESTS=ON", *std_cmake_args
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
