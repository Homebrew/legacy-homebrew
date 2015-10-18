class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "http://plplot.sourceforge.net"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.11.1%20Source/plplot-5.11.1.tar.gz"
  sha256 "289dff828c440121e57b70538b3f0fb4056dc47159bc1819ea444321f2ff1c4c"

  bottle do
    sha256 "81eb90e08ac42f6f5ea9f41159baf2cbf95f93f6f1390ddd1b12f00bb415e079" => :yosemite
    sha256 "7e4c364b66c61d7f35cb6a5417ee5ef1d06fe7a30d78b8d237a36b4beaa458f8" => :mavericks
    sha256 "b779762659e485d6c9cad54206b1e72f2db5e82950b19a356439e9ce3ef79138" => :mountain_lion
  end

  option "with-java"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "libtool" => :run
  depends_on "freetype"
  depends_on :x11 => :optional
  depends_on :fortran => :optional

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
