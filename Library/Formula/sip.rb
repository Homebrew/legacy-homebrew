class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "http://www.riverbankcomputing.co.uk/software/sip"
  url "https://downloads.sf.net/project/pyqt/sip/sip-4.16.5/sip-4.16.5.tar.gz"
  sha1 "d5d7b6765de8634eccf48a250dbd915f01b2a771"
  revision 1

  bottle do
    sha256 "0b6980e990a743676e7c1bac9a49a9a428c79b001bc40784e8d28b23bf119dcb" => :yosemite
    sha256 "b775749bcfafaf189f2bfae15a9ae40cb016d06cce41ef98a1cce5bd0c7b4abf" => :mavericks
    sha256 "ca4b9b761080abe76670072d000d256791a05a440bb608579759b3ca499c41ad" => :mountain_lion
  end

  head "http://www.riverbankcomputing.co.uk/hg/sip", :using => :hg

  depends_on :python => :recommended
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

      if Formula[python].installed? && which(python).realpath == (Formula[python].bin/python).realpath
        inreplace lib/"python#{version}/site-packages/sipconfig.py", Formula[python].prefix, Formula[python].opt_prefix
      end
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
