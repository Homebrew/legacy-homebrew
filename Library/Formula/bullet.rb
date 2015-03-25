class Bullet < Formula
  homepage "http://bulletphysics.org/wordpress/"
  url "https://bullet.googlecode.com/files/bullet-2.82-r2704.tgz"
  version "2.82"
  sha256 "67e4c9eb76f7adf99501d726d8ad5e9b525dfd0843fbce9ca73aaca4ba9eced2"
  head "https://github.com/bulletphysics/bullet3.git"

  depends_on "cmake" => :build

  deprecated_option "framework" => "with-framework"
  deprecated_option "shared" => "with-shared"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "build-extra" => "with-extra"
  deprecated_option "double-precision" => "with-double-precision"

  option :universal
  option "with-framework",        "Build Frameworks"
  option "with-shared",           "Build shared libraries"
  option "with-demo",             "Build demo applications"
  option "with-extra",            "Build extra library"
  option "with-double-precision", "Use double precision"

  def install
    args = []

    if build.with? "framework"
      args << "-DBUILD_SHARED_LIBS=ON" << "-DFRAMEWORK=ON"
      args << "-DCMAKE_INSTALL_PREFIX=#{frameworks}"
      args << "-DCMAKE_INSTALL_NAME_DIR=#{frameworks}"
    else
      args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    end

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"

    args << "-DBUILD_DEMOS=OFF" if build.without? "demo"

    # Demos require extras, see:
    # https://code.google.com/p/bullet/issues/detail?id=767&thanks=767&ts=1384333052
    if build.with?("extra") || build.with?("demo")
      args << "-DINSTALL_EXTRA_LIBS=ON"
    else
      args << "-DBUILD_EXTRAS=OFF"
    end

    system "cmake", *args
    system "make"
    system "make", "install"

    prefix.install "Demos" if build.with? "demo"
    prefix.install "Extras" if build.with? "extra"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "bullet/LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
