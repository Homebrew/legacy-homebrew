class Libsigcxx < Formula
  homepage "http://libsigc.sourceforge.net"
  url "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-2.4.1.tar.xz"
  sha256 "540443492a68e77e30db8d425f3c0b1299c825bf974d9bfc31ae7efafedc19ec"

  bottle do
    revision 1
    sha1 "92cf0ff33a45ef65d21897c35b27596af3839d7d" => :yosemite
    sha1 "6d1f631fc0c08e0d1f424012c7fbc78010decf99" => :mavericks
    sha1 "9495301790cc50a4719afeb26658a9d43e3b58dd" => :mountain_lion
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
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
    system ENV.cxx, "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
