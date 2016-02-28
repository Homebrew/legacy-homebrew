class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/BDE_3.0.0.0.tar.gz"
  sha256 "c6f295947c1af5f0d4e728e4d6801c4b29bb35a742faebc058f86b36722e8cdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "40fa82df85e35baec799c061a67719d7ada109d150f7eb9043761c4a2e40b0a2" => :el_capitan
    sha256 "3a95b87b049ba7aeb649a85a1948d80ba554d22603d0e336480f1b8787f75f4c" => :yosemite
    sha256 "0a4219cc1a605d20000b22d6a8c1977216b60d99278a8b92553ac30f14b6c595" => :mavericks
  end

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/v1.0.tar.gz"
    sha256 "9b3936fecef23f8c072e62208d2068decfd13d144b771125afc9e0fb9ad16d30"
  end

  def install
    buildpath.install resource("bde-tools")

    system "python", "./bin/waf", "configure", "--prefix=#{prefix}"
    system "python", "./bin/waf", "build"
    system "python", "./bin/waf", "install"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<-EOS.undent
      #include <bsl/bsl_string.h>
      #include <bsl/bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/bsl", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
