class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.83.5.tar.gz"
  sha256 "df6d58898d3d3bf117854dd64467dbd09625e048624c797649b46bf1c595b152"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any
    sha256 "1ea49cb319991969ada6567ffdfa227e2b2a1789371df29ab3468f13e35a1273" => :yosemite
    sha256 "cac6c51229ea72bb3ba4c174ed302d235a2bd34050e7834ff19af05931ff654b" => :mavericks
    sha256 "1e3e54e77cba617722599ccb0dde40b9b7858b054f1d24032fd458d4e0a04030" => :mountain_lion
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
