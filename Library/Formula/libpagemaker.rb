class Libpagemaker < Formula
  desc "Imports file format of Aldus/Adobe PageMaker documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
  url "http://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-0.0.3.tar.xz"
  sha256 "d896dc55dafd84ee3441e0ca497b810809f9eea44805a495c3843412309036d6"

  bottle do
    cellar :any
    sha256 "53a5b65d3e564c3583abb0a66b5c91a901b744f23514c0b6b3dd7963be1142b1" => :yosemite
    sha256 "50d6d238b10e8b529f9c2d82b2313220ce6f6fea5b1fb1e32d1029bb703c77df" => :mavericks
    sha256 "28612a90fd44189260c1ed7e55a43b73d0907b2dd414402030f109b6b171fb70" => :mountain_lion
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libpagemaker/libpagemaker.h>
      int main() {
        libpagemaker::PMDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libpagemaker-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lpagemaker-0.0"
    system "./test"
  end
end
