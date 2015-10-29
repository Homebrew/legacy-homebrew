class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.1.0.tar.gz"
  sha256 "2e34024b9b5d4c6a1db9326634f77c1eaab179c36382cb2a5f005c7ec702e8b9"

  bottle do
    cellar :any
    sha1 "5d2c6520ef505da92d44b9bafad53b032b6796e2" => :yosemite
    sha1 "4659c4bcc97959b40cbbc9212a3ff3b91b2df4eb" => :mavericks
    sha1 "0f3d59555b51ee9202a7d32a42e6f1aff3e9297d" => :mountain_lion
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
