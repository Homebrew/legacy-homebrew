require "formula"

class Libtins < Formula
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.1.tar.gz"
  sha1 "8047e87ba90f784d7022980c7351b616d43d4fba"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha1 "1312df6edac4a92790adba7184f73c65aaec376f" => :mavericks
    sha1 "66dc536e0612a5e66192e8ecb34f2c5e9cb9ed3d" => :mountain_lion
    sha1 "90b958acd1b71c96d99c0292a22731933a6ee456" => :lion
  end

  option :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args
    args << "-DLIBTINS_ENABLE_CXX11=1" if build.cxx11?

    system "cmake", ".", *args
    system "make", "install"
    doc.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-ltins", "-o", "test"
  end

end
