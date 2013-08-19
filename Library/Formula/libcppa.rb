require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  url 'https://github.com/Neverlord/libcppa/archive/V0.7.1.tar.gz'
  sha1 '0f1f685e94bfa16625370b978ff26deaf799b94e'

  depends_on 'cmake' => :build

  option 'with-opencl', 'Build with OpenCL actors'

  fails_with :gcc do
    build 5666
    cause 'libcppa requires a C++11 capable compiler.'
  end

  fails_with :llvm do
    build 2336
    cause 'libcppa requires a C++11 capable compiler.'
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --build-static
      --disable-context-switching
    ]

    if build.with? 'opencl'
      args << "--with-opencl"
    end

    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
