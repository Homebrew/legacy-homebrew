require "formula"

class Glbinding < Formula
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.0.2.tar.gz"
  sha1 "19d6d143bd4106582af4c197e882222e86323820"

  bottle do
    cellar :any
    sha1 "89417315c4b7b4da7c817700fecfd91692a39e9f" => :yosemite
    sha1 "6bfe54d1a5f99e8af3059d6b02353c2d53d9ea95" => :mavericks
    sha1 "6f9452c240bd6bd545af65c623e5068385acb206" => :mountain_lion
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
