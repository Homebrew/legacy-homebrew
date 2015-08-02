class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.83.4.tar.gz"
  sha256 "2cf287cead9a116c56f6d6f15f73dc8b3ed1fe407ef2ca894027d585fab07341"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "4dea2d45fd71ae072e95f2e0c85030298ed9789f01e19d8171429e2c89abe8f4" => :yosemite
    sha256 "891b36d8dc81d0f0335ecb936acdddb4fd0fe1d96352af5b325003230cc40811" => :mavericks
    sha256 "a2faed86dda67fe343ccbd302a0598dcde27b41868d057f048a27fe80145a4f0" => :mountain_lion
  end

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
