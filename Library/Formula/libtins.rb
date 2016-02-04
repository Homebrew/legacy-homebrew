class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.3.tar.gz"
  sha256 "7e498cb1acb12779b2e6e3404c9e3792b068fbfc905775750c521d6845815a15"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "3171b46d86b4eabf9b9d4e18a5338dccc0439947a21e655d8acc8f318d193c09" => :el_capitan
    sha256 "6474be2414fe6ae78939b5b21ac7e547f67b7717c58085e1cdd5945c369b872f" => :yosemite
    sha256 "af9051d11be6d28d95270a80e718a4651d39e32f51e7ba633e0917b410fc1e60" => :mavericks
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
