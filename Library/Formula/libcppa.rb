require "formula"

class Libcppa < Formula
  homepage "http://libcppa.blogspot.it"
  url "http://github.com/Neverlord/libcppa/archive/V0.9.4.tar.gz"
  sha1 "eba8002f087e55498edc0bf996fb7f211d7feec6"

  bottle do
    cellar :any
    sha1 "a90dee39274040acf70868ccc636e8c14e7c7ad5" => :mavericks
    sha1 "3ef83c6fad796a1e50f6fd417b81825a44f606d5" => :mountain_lion
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
