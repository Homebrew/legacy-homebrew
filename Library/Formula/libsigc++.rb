class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.6/libsigc++-2.6.1.tar.xz"
  sha256 "186f2167c1b3d90529ce8e715246bf160bc67ec1ec19f4e45d76c0ae54dfbe1b"

  bottle do
    cellar :any
    revision 1
    sha256 "2432f8ce2c0da7ad738da40914362be21c354d139a35865404aa3a4afe6d5443" => :el_capitan
    sha256 "c359344a9687379f811feef287e38eb344a18042e16194f26e40521fdf625f6b" => :yosemite
    sha256 "258748c43eb3d2d530b382cbee57b42ad6f1cea7eab162791f113bd30f07ebd0" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
