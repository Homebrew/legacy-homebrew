require "formula"

class Glbinding < Formula
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.0.2.tar.gz"
  sha1 "19d6d143bd4106582af4c197e882222e86323820"

  depends_on "cmake" => :build
  needs :cxx11

  def caveats
      "glbinding requires a C++11 compliant compiler"
  end

  fails_with :gcc do
    cause 'glbinding requires a C++11 compliant compiler.'
  end

  fails_with :llvm do
    cause 'glbinding requires a C++11 compliant compiler.'
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
      EOS
    flags = ["-std=c++11", "-stdlib=libc++", "-I#{include}/glbinding", "-I#{lib}/glbinding", "-lglbinding"]
    system ENV.cxx, "-o", "test", "test.cpp", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end

end

