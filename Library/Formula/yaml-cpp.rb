class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/release-0.5.3.tar.gz"
  sha256 "ac50a27a201d16dc69a881b80ad39a7be66c4d755eda1f76c3a68781b922af8f"

  bottle do
    cellar :any
    sha256 "20b38c2f7c47550b458cb5b6f054795d90f4955d2525656e6d713cdbe7d451b1" => :el_capitan
    sha256 "e0a51ff0b33568695412fe43cdc51b26642ae46dfb6dac56b813295057c91bb6" => :yosemite
    sha256 "c779f86632b38472e022ad91f0f5ddb0f399fd547d36cbc5494a76c0f6becd48" => :mavericks
  end

  option :cxx11
  option :universal
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  if build.cxx11? && MacOS.version < :mavericks
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
