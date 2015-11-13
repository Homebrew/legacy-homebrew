class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.6/libsigc++-2.6.2.tar.xz"
  sha256 "fdace7134c31de792c17570f9049ca0657909b28c4c70ec4882f91a03de54437"

  bottle do
    cellar :any
    sha256 "e05bb72083f15eb00759fb6da20f05efcae4f0caf925913b350646891ba83564" => :el_capitan
    sha256 "f3ef9a7150b278423eff444ea57aede51e3236c09fa7ef5a88fe26438ca422dc" => :yosemite
    sha256 "8e953bc77aeb93ea50568a53472dd9bc2651675e46c57dac2b87b93c40c7df3e" => :mavericks
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
