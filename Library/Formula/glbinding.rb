class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.1.0.tar.gz"
  sha256 "2e34024b9b5d4c6a1db9326634f77c1eaab179c36382cb2a5f005c7ec702e8b9"

  bottle do
    sha256 "267be079b0657c4cc1cb4002bf4047d358630404e2ea0bcb966a5730b6a0641e" => :el_capitan
    sha256 "39355e37b3417a03a2b8ee7ce46fa27cdf72706a4ee4227fbe8cdfd9fa3a8e05" => :yosemite
    sha256 "d4e319797d5b4dbf44dcd99f01de934941d7e39e82bcf66508853b386b2bdeab" => :mavericks
  end

  depends_on "cmake" => :build
  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding",
                    "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
