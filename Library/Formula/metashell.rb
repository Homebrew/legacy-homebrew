class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "https://github.com/sabel83/metashell"
  url "https://github.com/sabel83/metashell/archive/v2.0.0.tar.gz"
  sha1 "4dec47b6ee32cdf179b2eb297c289b296d3fba8f"

  bottle do
    sha1 "35cb28330f73ec44ecf27244347805dc2561439f" => :yosemite
    sha1 "0d8a62d552ae6ff960ac26fe8344181ed62895d5" => :mavericks
    sha1 "76874d93ced1815ccfcbddb6da75e8c56aff44e4" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    # Build internal Clang
    mkdir "templight/build" do
      system "cmake", "../llvm", "-DLIBCLANG_BUILD_STATIC=ON", *std_cmake_args
      system "make", "clang"
      system "make", "libclang"
      system "make", "libclang_static"
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
