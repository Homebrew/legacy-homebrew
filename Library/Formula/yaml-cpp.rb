class YamlCpp < Formula
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/release-0.5.2.tar.gz"
  sha256 "6fb92f6f5925e0af918ffbb90acf19b7b88706ebcd40fc186b7caa76609b6350"

  bottle do
    cellar :any
    revision 1
    sha256 "90e07cbad706bc9e3052e91018a2389c8a592e700b0a2c3933d253f933e2c554" => :yosemite
    sha256 "52257d4f7c38fb6baadfed2f8ed4c0b1731ec0b019bfe463087246b7b3e806f5" => :mavericks
    sha256 "ed92a64681670a01dbe3113a900b614798179153bbecbf3cea1b24845ad3fa80" => :mountain_lion
  end

  option :cxx11
  option :universal
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
