class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.1.tar.gz"
  sha256 "20662ed75699358078aacaf36f38cbd25a9b2bd9ae2c77b7193733c917aab651"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    revision 1
    sha1 "3f7a5a404ce751fe953100f8a282490dec1eed2a" => :yosemite
    sha1 "316b0d0b1255f9aa25b257a29f1900c49ec09046" => :mavericks
    sha1 "85fb8ad451c673cb5cc918294e563525a95824ae" => :mountain_lion
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
