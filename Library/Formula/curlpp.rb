class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "http://www.curlpp.org"
  url "https://github.com/jpbarrette/curlpp/archive/v0.7.3.tar.gz"
  sha256 "b72093f221a9e2d0f7ce0bd0f846587835e01607a7bb0f106ff4317a8c30a81c"

  bottle do
    cellar :any
    revision 1
    sha256 "f46b151ea329f356276dc42b8079df56e7ad481e5618686eb6e591766f9e0c09" => :el_capitan
    sha256 "35fab07062b0420738fbf1c45461ca2aee7e5631c070b935f35855f993243b3e" => :yosemite
    sha256 "fa44ece8e8e1285f1aa420d69abeda7457bf6e7303be0e7931f66ef4a180add9" => :mavericks
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
          myHandle.setOpt(new curlpp::options::Url("https://google.com"));
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
