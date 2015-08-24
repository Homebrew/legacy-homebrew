class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "https://github.com/sabel83/metashell"
  url "https://github.com/sabel83/metashell/archive/v2.1.0.tar.gz"
  sha256 "64d3680a536a254de8556a9792c5d35e6709f2f347d7187614271123d87246ee"
  depends_on "cmake" => :build

  bottle do
    sha1 "35cb28330f73ec44ecf27244347805dc2561439f" => :yosemite
    sha1 "0d8a62d552ae6ff960ac26fe8344181ed62895d5" => :mavericks
    sha1 "76874d93ced1815ccfcbddb6da75e8c56aff44e4" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    # Build internal Clang
    mkdir "3rd/templight/build" do
      system "cmake", "../llvm", "-DLIBCLANG_BUILD_STATIC=ON", *std_cmake_args
      system "make", "clang"
      system "make", "libclang"
      system "make", "libclang_static"
      system "make", "templight"
    end

    if MacOS.version == :yosemite
      system "tools/clang_default_path", "--gcc=clang", ">", "lib/core/extra_sysinclude.hpp"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.hpp").write <<-EOS.undent
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    assert_match /const int/, shell_output("cat #{testpath}/test.hpp | #{bin}/metashell -H")
  end
end
