require "formula"

class Glbinding < Formula
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.0.2.tar.gz"
  sha1 "19d6d143bd4106582af4c197e882222e86323820"

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
