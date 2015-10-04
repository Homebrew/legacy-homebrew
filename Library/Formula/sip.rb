class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "http://www.riverbankcomputing.co.uk/software/sip"
  url "https://downloads.sourceforge.net/project/pyqt/sip/sip-4.16.9/sip-4.16.9.tar.gz"
  sha256 "dbe173aa566e26ca0bb5bcbc1d30ef780f416267bb3b5df48149a737ea6b0555"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "902c988504e52b3a69742b3b13b08f4ac4d33f46b80e65201a692417a95e68c3" => :el_capitan
    sha256 "a88bff5227829979cc96ccb956f73e3a39c1e8e885f02d39e30a6040faf4d2e8" => :yosemite
    sha256 "777e09e3635c2f445146e5f4612a3f812a7c40ce2ba47309703a0df1163992f2" => :mavericks
    sha256 "8832546d36baa62fdecd0df427ba4f3b02ab2f39fc5fcb47f114ae5020f11342" => :mountain_lion
  end

  head "http://www.riverbankcomputing.co.uk/hg/sip", :using => :hg

  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "sip: --with-python3 must be specified when using --without-python"
  end

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download + ".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    Language::Python.each_python(build) do |python, version|
      # Note the binary `sip` is the same for python 2.x and 3.x
      system python, "configure.py",
                     "--deployment-target=#{MacOS.version}",
                     "--destdir=#{lib}/python#{version}/site-packages",
                     "--bindir=#{bin}",
                     "--incdir=#{include}",
                     "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system "make"
      system "make", "install"
      system "make", "clean"
    end
  end

  def post_install
    mkdir_p "#{HOMEBREW_PREFIX}/share/sip"
  end

  def caveats
    "The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip."
  end

  test do
    (testpath/"test.h").write <<-EOS.undent
      #pragma once
      class Test {
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
      #include "test.h"
      #include <iostream>
      Test::Test() {}
      void Test::test()
      {
        std::cout << "Hello World!" << std::endl;
      }
    EOS
    (testpath/"test.sip").write <<-EOS.undent
      %Module test
      class Test {
      %TypeHeaderCode
      #include "test.h"
      %End
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"generate.py").write <<-EOS.undent
      from sipconfig import SIPModuleMakefile, Configuration
      m = SIPModuleMakefile(Configuration(), "test.build")
      m.extra_libs = ["test"]
      m.extra_lib_dirs = ["."]
      m.generate()
    EOS
    (testpath/"run.py").write <<-EOS.undent
      from test import Test
      t = Test()
      t.test()
    EOS
    system ENV.cxx, "-shared", "-o", "libtest.dylib", "test.cpp"
    system "#{bin}/sip", "-b", "test.build", "-c", ".", "test.sip"
    Language::Python.each_python(build) do |python, version|
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
      system python, "generate.py"
      system "make", "-j1", "clean", "all"
      system python, "run.py"
    end
  end
end
