class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/release-0.5.2.tar.gz"
  sha256 "6fb92f6f5925e0af918ffbb90acf19b7b88706ebcd40fc186b7caa76609b6350"

  bottle do
    cellar :any
    sha256 "88c3a00522e35571fbd6e8a7ad065956442edd7e8a7ad57b4804f7249450c85d" => :el_capitan
    sha256 "9727c8af2fe48f0d3c7cd3a031f92cb22a5f475bf8aeebecacf81d3bc425aff8" => :yosemite
    sha256 "58eb6496d8d6e95398fab4d4ace176c0d42284c44ccb9cda3cc9304b29804395" => :mavericks
    sha256 "6eeeae8bcc43b2425f09184666cdf7b8df9228d94ca64761d6fefc57c7936918" => :mountain_lion
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
