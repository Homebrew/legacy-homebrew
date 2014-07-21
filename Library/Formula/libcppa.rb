require "formula"

class Libcppa < Formula
  homepage "http://libcppa.blogspot.it"
  url "http://github.com/Neverlord/libcppa/archive/V0.9.4.tar.gz"
  sha1 "eba8002f087e55498edc0bf996fb7f211d7feec6"

  bottle do
    cellar :any
    sha1 "4527da9b1c0e6a60c13cf7a35540fceaa2caa3b2" => :mavericks
    sha1 "cee8d1916bcd7eebfc151a6712e1efd58d54c4c1" => :mountain_lion
    sha1 "d30dbe35371a62ddd9f34ada0210a3770d05191d" => :lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  option "with-opencl", "Build with OpenCL actors"
  option "with-examples", "Build examples"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --build-static
      --disable-context-switching
    ]

    args << "--with-opencl" if build.with? "opencl"
    args << "--no-examples" if build.without? "examples"

    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
