class Fifechan < Formula
  desc "Is a C++ GUI library designed for games."
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.2.tar.gz"
  sha256 "4a4239314ae33c5413e4d7d3e5f2f1a7e53fb596fd1480ea7443ee78041e6b2d"

  depends_on "cmake" => :build
  depends_on "allegro" => :build
  depends_on "sdl_image" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"fifechan_test.cpp").write <<-EOS
    #include <fifechan.hpp>
    int main(int n, char** c) {
      fcn::Container* mContainer = new fcn::Container();
      if (mContainer == nullptr) {
        return 1;
      }
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test", "fifechan_test.cpp"
    system "./fifechan_test"
  end
end
