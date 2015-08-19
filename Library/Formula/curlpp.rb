class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/archive/v0.7.3.tar.gz"
  sha256 "b72093f221a9e2d0f7ce0bd0f846587835e01607a7bb0f106ff4317a8c30a81c"

  bottle do
    cellar :any
    sha256 "02c9fcff3e1f44aa6a6a2b7d11f3430be4408c2e8ceaec592819a7e80761c492" => :yosemite
    sha256 "212198492acef15ac67840e80d052f451a02531a04632aa49a4b12dde9baec3a" => :mavericks
    sha256 "89d6e74a2ec2482014e6210876eeface47b23b1388f54553c9073c982cd0ddcb" => :mountain_lion
  end

  depends_on "boost" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <curlpp/cURLpp.hpp>
      #include <curlpp/Easy.hpp>
      #include <curlpp/Options.hpp>
      #include <curlpp/Exception.hpp>

      int main() {
        try {
          curlpp::Cleanup myCleanup;
          curlpp::Easy myHandle;
          myHandle.setOpt(new curlpp::options::Url("http://google.com"));
          myHandle.perform();
        } catch (curlpp::RuntimeError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        } catch (curlpp::LogicError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcurl", "-lcurlpp", "-o", "test"
    system "./test"
  end
end
