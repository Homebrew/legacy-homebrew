require "formula"

class Libcppa < Formula
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.11.0.tar.gz"
  sha1 "202f2fd72a5af59d7ace6b7300df1fcc19f1857f"

  # since upstream has rename the project to actor-framework (or libcaf in its
  # pkgconfig file), we need to rename libcppa to libcaf in the future

  bottle do
    cellar :any
    sha1 "a90dee39274040acf70868ccc636e8c14e7c7ad5" => :mavericks
    sha1 "3ef83c6fad796a1e50f6fd417b81825a44f606d5" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  option "with-opencl", "Build with OpenCL actors"
  option "with-examples", "Build examples"
  option "without-check", "Skip build-time tests (not recommended)"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --build-static
    ]

    args << "--no-opencl" if build.without? "opencl"
    args << "--no-examples" if build.without? "examples"

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "check"
    system "make", "install"
  end
end
