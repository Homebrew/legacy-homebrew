class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/BDE_3.0.0.0.tar.gz"
  sha256 "c6f295947c1af5f0d4e728e4d6801c4b29bb35a742faebc058f86b36722e8cdd"

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
