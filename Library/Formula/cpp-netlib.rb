require "formula"

class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "http://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1RC2.tar.gz"
  sha1 "3d50619980f5fcab7baecfa0a34fc9e54a7f5884"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"
  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/'CMakeLists.txt').write <<-EOM.undent
        find_package(Boost COMPONENTS thread system)
        include_directories(${Boost_INCLUDE_DIRS})
        find_package(cppnetlib)
        include_directories(${CPPNETLIB_INCLUDE_DIRS})
        add_executable(test test.cpp)
        target_link_libraries(test ${Boost_LIBRARIES})
        target_link_libraries(test ${CPPNETLIB_LIBRARIES})
    EOM
    (testpath/'test.cpp').write <<-EOS.undent
        #include <boost/network/protocol/http/client.hpp>
        int main(int argc, char *argv[]) {
            using namespace boost::network;
            http::client client;
            http::client::request request("");
            return 0;
        }
    EOS
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "test"
    system "./test"
  end
end
