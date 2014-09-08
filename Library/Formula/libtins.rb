require "formula"

class Libtins < Formula
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.1.tar.gz"
  sha1 "8047e87ba90f784d7022980c7351b616d43d4fba"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    sha1 "a192104ba75ed438f9238f8e574ff89d6616b337" => :mavericks
    sha1 "5eb5c9d9c7165d70d98473b06b8faadbd5b3133b" => :mountain_lion
    sha1 "b8bbdf13d0d00d963195bf749a4f51d67e20fb2d" => :lion
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
