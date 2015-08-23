class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"
  sha256 "dcd5448f31ded71c7bd22fddd7d816ac590ae7b97e1fdda8d1253f8ff3655571"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any
    sha256 "79e79f3dcc6dbe62ca2422df12469a545be28ee150eaba3d67fa66826da7c730" => :yosemite
    sha256 "bc42f536182a138dc1007df0ab7188a9c8fbaa6e6c9ac27d1ed550ab1372816f" => :mavericks
    sha256 "f63b943a84faa74f80756ba3aae7b3c12f6a934a50953fcf367a7f088c769615" => :mountain_lion
  end

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

  depends_on "cmake" => :build

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

    # Related to the following warnings when building --with-shared --with-demo
    # https://gist.github.com/scpeters/6afc44f0cf916b11a226
    if build.with?("demo") && (build.with?("shared") || build.with?("framework"))
      raise "Demos cannot be installed with shared libraries or framework."
    end

    args << "-DBUILD_BULLET2_DEMOS=OFF" if build.without? "demo"

    if build.with?("extra")
      args << "-DINSTALL_EXTRA_LIBS=ON"
    else
      args << "-DBUILD_EXTRAS=OFF"
    end

    system "cmake", *args
    system "make"
    system "make", "install"

    prefix.install "examples" if build.with? "demo"
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
