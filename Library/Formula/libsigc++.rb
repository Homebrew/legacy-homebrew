class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.4/libsigc++-2.4.1.tar.xz"
  sha256 "540443492a68e77e30db8d425f3c0b1299c825bf974d9bfc31ae7efafedc19ec"

  bottle do
    sha256 "20c65462fad1a772c4dd0d001d94641577c1be2760ad6fa08ba6945b1a303761" => :yosemite
    sha256 "1df44b807cd8607f84917d53439718c94237139702b1fe533f3fc4fd3d1de014" => :mavericks
    sha256 "37ccdaab3df9890cd9796dae58e16d8e49defca6d889be0d763cadfdd2f9bc0b" => :mountain_lion
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
