class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.8/libsigc++-2.8.0.tar.xz"
  sha256 "774980d027c52947cb9ee4fac6ffe2ca60cc2f753068a89dfd281c83dbff9651"

  bottle do
    cellar :any
    sha256 "424a330a087707c8928b5f4cf9d0b3dfddf08de756f97ec1c3a7804deeb8f821" => :el_capitan
    sha256 "0e96ca0e92accf72c268ef1c01f34a00d85e3e4f30b37af92605556a8ec932bf" => :yosemite
    sha256 "d040deee02f6c61ace3fc8ec372bf2280e1c350fbc56c328aca133ae8d16ab82" => :mavericks
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
