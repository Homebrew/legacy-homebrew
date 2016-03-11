class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.4.tar.gz"
  sha256 "b94935b5fb40668ce5acb87d4f26970b47bfa25ba5f34aeaab70d8a422a9b192"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "6b4deb14daedc0aa3b04135c03af037dcfe2bfec1530b936fb0d53faf3625935" => :el_capitan
    sha256 "a5b719826e8489a77d4876dc2830d3b0f2bca958eb75522a2a4efc016a80edf5" => :yosemite
    sha256 "8ab57bfc2aeb4a03ced61069901744de9f328b37cd2f1f79d351c58e53f6a730" => :mavericks
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "openssl"

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
