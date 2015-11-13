class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.6/libsigc++-2.6.2.tar.xz"
  sha256 "fdace7134c31de792c17570f9049ca0657909b28c4c70ec4882f91a03de54437"

  bottle do
    cellar :any
    sha256 "7cb0428fce126cba9275b8212eedc7f56544829c52aec30096c7bc64a51e8d8a" => :el_capitan
    sha256 "68673c2a78a593dafb0c980e00b87057c449c0a751fca4ee10a678d57f00a958" => :yosemite
    sha256 "3bc196123da746ebdbab0902faf5bd9b2043e51530085c651bdad1f36292b011" => :mavericks
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
