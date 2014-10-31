require "formula"

class Libcppa < Formula
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.11.0.tar.gz"
  sha1 "202f2fd72a5af59d7ace6b7300df1fcc19f1857f"

  # since upstream has rename the project to actor-framework (or libcaf in its
  # pkgconfig file), we need to rename libcppa to libcaf in the future

  bottle do
    cellar :any
    sha1 "b0e9bef1983d561763e21539c9b9196d75e5a935" => :yosemite
    sha1 "ed71bb57236d2aecf4e19e5044ca3af22969b5c5" => :mavericks
    sha1 "8224fe20d5d4bd184a9b6c15ddd6143740ea23ca" => :mountain_lion
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
