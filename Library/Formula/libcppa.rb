require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  url 'https://github.com/Neverlord/libcppa/archive/V0.7.1.tar.gz'
  sha1 '0f1f685e94bfa16625370b978ff26deaf799b94e'

  depends_on :macos => :lion
  depends_on 'cmake' => :build

  option 'with-opencl', 'Build with OpenCL actors'

  def caveats
      "Libcppa requires a C++11 compliant compiler"
  end

  fails_with :gcc do
    cause 'libcppa requires a C++11 compliant compiler.'
  end

  fails_with :llvm do
    cause 'libcppa requires a C++11 compliant compiler.'
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
