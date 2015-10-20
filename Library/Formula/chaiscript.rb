class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v5.7.1.tar.gz"
  sha256 "333ba4317c318b9a7fa36cb8e93353c477b43fab051f787b4f587f0a82ca6fa3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e28fad6a4367dba0f1ae5ab768cc2df103466d59a0db1374a3b7a2cc71abeaeb" => :el_capitan
    sha256 "604a16f4a3c987ac050ae13327297a0f83d0a3dead05f98a843fdc134084530f" => :yosemite
    sha256 "ba81c0119afe95219526ae4f197a75fa5d97aa82075ff1222eb525a0084cb4e6" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <chaiscript/chaiscript.hpp>
      #include <chaiscript/chaiscript_stdlib.hpp>
      #include <cassert>
      int main() {
        chaiscript::ChaiScript chai(chaiscript::Std_Lib::library());
        assert(chai.eval<int>("123") == 123);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-std=c++11", "-o", "test"
    system "./test"
  end
end
