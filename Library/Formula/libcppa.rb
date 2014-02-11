require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  url 'http://github.com/Neverlord/libcppa/archive/V0.8.1.tar.gz'
  sha1 'd4f096aae2bb72e254ad6df45edf3fb62370acaa'

  depends_on :macos => :lion
  depends_on 'cmake' => :build

  option 'with-opencl', 'Build with OpenCL actors'
  option 'with-examples', 'Build examples'

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

    args << '--with-opencl' if build.with? 'opencl'
    args << '--no-examples' unless build.with? 'examples'

    system "./configure", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
