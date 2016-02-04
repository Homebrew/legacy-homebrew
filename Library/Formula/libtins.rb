class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.3.tar.gz"
  sha256 "7e498cb1acb12779b2e6e3404c9e3792b068fbfc905775750c521d6845815a15"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "b3ac13ab31ddea15e2301d06ffd574fa60c50dadad0280a16f2205da60996de0" => :yosemite
    sha256 "1bb3d6c1054cb1220dc1391cb24ae5f6945a43ecfe23f9a83591070ccdff3d0a" => :mavericks
    sha256 "47c40947daec2e61f06e18d763803377cbed148fb4b32a93ee3a052e6b0d62ef" => :mountain_lion
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
