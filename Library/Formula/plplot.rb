class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "http://plplot.sourceforge.net"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.11.0%20Source/plplot-5.11.0.tar.gz"
  sha256 "bfa8434e6e1e7139a5651203ec1256c8581e2fac3122f907f7d8d25ed3bd5f7e"

  bottle do
    revision 1
    sha256 "c7721f7d2cd4aa9f9e9724bb7e97dbeadcbafe9e9d3f331a56a97986b88bf896" => :yosemite
    sha256 "394ee113bdf444ec5c2a50fd379f283cfa85de3a6d04fe7a673a2e8c211c2264" => :mavericks
    sha256 "39b18e81232ae3987018662035c49a441ddd0f0fcbe9d7534620d512b7f2910c" => :mountain_lion
  end

  option "with-java"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "libtool" => :run
  depends_on "freetype"
  depends_on :x11 => :optional
  depends_on :fortran => :optional

  # patch taken from http://sourceforge.net/p/plplot/bugs/163/
  # already include upstream, should be removed when update is released
  patch :p0 do
    url "http://sourceforge.net/p/plplot/bugs/163/attachment/cmake_modules_pkg-config.cmake.diff"
    sha256 "eb33a578ddf2bb06db9d700f25ab12febe27f3ce43bccbf734011859566d9531"
  end

  def install
    args = std_cmake_args
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"
    args << "-DENABLE_f95=OFF" if build.without? "fortran"
    args << "-DENABLE_ada=OFF" << "-DENABLE_d=OFF" << "-DENABLE_qt=OFF" \
         << "-DENABLE_lua=OFF" << "-DENABLE_tk=OFF" << "-DENABLE_python=OFF" \
         << "-DENABLE_tcl=OFF" << "-DPLD_xcairo=OFF" << "-DPLD_wxwidgets=OFF" \
         << "-DENABLE_wxwidgets=OFF"

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <plplot.h>

      int main(int argc, char *argv[]) {
        plparseopts( &argc, argv, PL_PARSE_FULL );
        plsdev( "extcairo" );
        plinit();
        return 0;
      }
    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}/plplot
      -L#{lib}
      -lcsirocsa
      -lltdl
      -lm
      -lplplot
      -lqsastime
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
